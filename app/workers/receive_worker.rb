# Processes deposit transactions on Cryptsy and credits accounts at the current spot price
class ReceiveWorker
  include Sidekiq::Worker

  def perform
    client = CryptoTeller.cryptsy_client

    transactions = client.transactions.select do |tx|
      tx.type == 'Deposit'
    end

    transactions.each do |tx|
      address = Address.find_by(address: tx.address)
      if address
        log('sell_order.received', tx_id: tx.txrid, address: tx.address, currency: tx.currency, amount: tx.amount)
        normalize_exchange_account(tx)
        process(tx, address.account)
      else
        log('sell_order.ignored', tx_id: tx.txrid, address: tx.address)
      end
    end
  end

  private

  def process(tx, account)
    amount = CryptoTeller.price_service.to_usd(tx.currency, tx.amount.to_f)

    log('sell_order.valued', currency: tx.currency, amount: amount)

    order = account.orders.create!(
      direction: 'sell',
      amount: amount,
      status: 'completed',
      note: 'Order completed',
      address: tx.address,
      currency: tx.currency,
      transaction_id: tx.trxid
    )

    account.balance += amount
    account.save!

    log('sell_order.credited', account_id: account.id, amount: amount)
  end

  def normalize_exchange_account(tx)
    unless tx.currency == 'BTC'
      log('sell_order.instant_sell', currency: tx.currency, amount: tx.amount)
      CryptoTeller.trade_service.instant_sell(tx.currency, 'BTC', tx.amount)
    end
  end

  def log(*args)
    Fluent::Logger.post(*args)
  end
end
