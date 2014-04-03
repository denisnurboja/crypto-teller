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
        break if client.orders(market_id).none? { |o| o.orderid == order_id }
        sleep RETRY_INTERVAL
      end
    end
  end # TradeService
end # CryptoTeller
