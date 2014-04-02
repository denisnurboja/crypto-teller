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
        logger.info "Processing deposit to #{tx.address} for #{tx.amount} #{tx.currency}"
        process(tx, address.account)
      else
        logger.debug "Ignoring deposit #{tx.trxid} to #{tx.address}"
      end
    end
  end

  private

  def process(tx, account)
    amount = CryptoTeller.price_service.to_usd(tx.currency, tx.amount.to_f)

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
  end
end
