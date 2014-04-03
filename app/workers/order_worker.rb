class OrderWorker
  include Sidekiq::Worker

  CONFIRM_WITHDRAWAL_PATTERN = /^https:\/\/www.cryptsy.com(\/users\/confirmwithdrawal\/.*)/

  def perform(order_id)
    order = Order.find(order_id)
    account = order.account

    if validate(order, account)
      begin
        amount = CryptoTeller.price_service.from_usd(order.currency, order.amount)

        log('buy_order.valued', currency: order.currency, amount: amount)

        prepare_exchange_account(order.currency, amount)
        withdraw(order.currency, order.address, amount)
        confirm_withdrawal

        finalize(order, account)
      rescue
        recover(order, amount)
        raise
      end
    end
  end

  private

  def validate(order, account)
    return unless order.status == 'pending'

    if order.buy?
      if account.balance >= order.amount
        account.hold(order.amount)
        account.save!
      else
        order.update!(status: 'rejected', note: 'Insufficient balance in account')
        return
      end
    else
      order.update!(status: 'rejected', note: 'Not authorized to create sell orders')
      return
    end

    order.update!(status: 'accepted', note: 'Order accepted')
    log('buy_order.accepted', order_id: order.id)
  end

  # Ensure that exchange account has sufficient balance for withdrawal
  def prepare_exchange_account(currency, amount)
    client = CryptoTeller.cryptsy_client

    balance = client.balance(currency)

    difference = (amount - balance).round(8)
    if difference > 0
      log('buy_order.instant_buy', currency: currency, amount: difference)
      # TODO What to do if insufficient BTC balance?
      CryptoTeller.trade_service.instant_buy(currency, 'BTC', difference)
    end
  end

  # Submit withdrawal order through web client, confirm via email
  def withdraw(currency, address, amount)
    currency_id = CryptoTeller.currency_data.fetch(currency.upcase).id

    web_client = CryptoTeller.cryptsy_web_client

    web_client.login
    web_client.pincode

    log('buy_order.withdrawal', currency_id: currency_id, address: address, amount: amount)
    result = web_client.make_withdrawal(currency_id, address, amount)

    unless result.success?
      raise 'Withdrawal failed'
    end
  end

  # Confirms withdrawal links in email
  def confirm_withdrawal
    adapter = CryptoTeller.gmail_adapter
    web_client = CryptoTeller.cryptsy_web_client

    poller = Cryptsy::ConfirmationPoller.new(adapter, CONFIRM_WITHDRAWAL_PATTERN)
    poller.run_until_found.each do |link|
      log('buy_order.confirm_withdrawal', url: link)
      web_client.get(link)
    end

    adapter.logout
  end

  def recover(order, account)
    account.unhold(order.amount)
    account.save!

    order.update!(status: 'canceled', note: 'Internal error occured during order')
  end

  def finalize(order, account)
    account.held_balance -= order.amount
    account.save!

    order.update!(status: 'completed', note: 'Order completed')
  end

  def log(*args)
    Fluent::Logger.post(*args)
  end
end
