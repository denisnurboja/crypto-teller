module CryptoTeller
  class TradeService
    attr_accessor :client

    RETRY_INTERVAL = 1

    def instant_buy(left, right, amount)
      market = client.market_by_pair(left, right)

      # Find the lowest price that results in execution
      lowest_price = client.market_orders(market.marketid).sellorders.find { |order|
        order.quantity.to_f >= amount.to_f
      }.sellprice

      order = client.create_buy_order(market.marketid, amount, lowest_price)

      await_execution(market.marketid, order.orderid, amount.to_f)
    end

    def instant_sell(left, right, amount)
      market = client.market_by_pair(left, right)

      # Find the highest  price that results in execution
      highest_price = client.market_orders(market.marketid).buyorders.find { |order|
        order.quantity.to_f >= amount.to_f
      }.buyprice

      order = client.create_sell_order(market.marketid, amount, highest_price)

      await_execution(market.marketid, order.orderid, amount.to_f)
    end

    private

    def await_execution(market_id, order_id, amount)
      loop do
        break if calculate_remaining(market_id, order_id, amount) == 0
        sleep RETRY_INTERVAL
      end
    end

    def calculate_remaining(market_id, order_id, amount)
      trades = client.trades(market_id).find_all do |trade|
        trade.order_id == order_id
      end

      amount - trades.map { |t| t.quantity.to_f }.inject(0, :+)
    end
  end # TradeService
end # CryptoTeller
