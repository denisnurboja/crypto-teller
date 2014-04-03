class OrderWorker
  include Sidekiq::Worker

  CONFIRM_WITHDRAWAL_PATTERN = /^https:\/\/www.cryptsy.com(\/users\/confirmwithdrawal\/.*)/

  def perform(order_id)
    order = Order.find(order_id)
    account = order.account

    if validate(order, account)
      amount = CryptoTeller.price_service.from_usd(order.currency, order.amount)

      prepare_exchange_account(order.currency, amount)
      withdraw(order.currency, order.address, amount)
      confirm_withdrawal

      finalize(order, account)
    end
  end

  private

  def validate(order, account)
    if order.buy?
      if account.balance >= order.amount
        account.hold(order.amount)
        account.save!
      else
        order.update_attributes!(status: 'rejected', note: 'Insufficient balance in account')
        return
      end
    else
      order.update_attributes!(status: 'rejected', note: 'Not authorized to create sell orders')
      return
    end

    order.update_attributes!(status: 'accepted', note: 'Order accepted')
  end

  # Ensure that exchange account has sufficient balance for withdrawal
  def prepare_exchange_account(currency, amount)
    client = CryptoTeller.cryptsy_client

    balance = client.info.balances_available(currency.upcase).to_f
    unless balance >= amount
      # TODO What to do if insufficient BTC balance?
      CryptoTeller.trade_service.instant_buy(currency, 'BTC', amount - balance)
    end
  end

  # Submit withdrawal order through web client, confirm via email
  def withdraw(currency, address, amount)
    currency_id = CryptoTeller.currency_data.fetch(currency.upcase).id

    web_client = CryptoTeller.cryptsy_web_client

    web_client.login
    web_client.pincode
    web_client.make_withdrawal(currency_id, address, amount)
  end

  # Confirms withdrawal links in email
  def confirm_withdrawal
    adapter = CryptoTeller.gmail_adapter
    web_client = CryptoTeller.cryptsy_web_client

    poller = Cryptsy::ConfirmationPoller.new(gmail_adapter, CONFIRM_WITHDRAWAL_PATTERN)
    poller.run_until_found.each do |link|
      web_client.get(link)
    end

    adapter.logout
  end

  def finalize(order, account)
    account.held_balance -= order.amount
    account.save!

    order.update_attributes!(status: 'completed', note: 'Order completed')
  end
end
