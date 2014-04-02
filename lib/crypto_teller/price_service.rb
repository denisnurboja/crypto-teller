module CryptoTeller
  class PriceService
    attr_accessor :cryptsy_client
    attr_accessor :coinbase_client
    attr_accessor :cache

    # From USD to X
    def from_usd(currency, amount)
      amount_btc = amount / coinbase_buy_price
      if currency == 'BTC'
        amount_btc
      else
        amount_btc / spot_price(currency, 'BTC')
      end
    end

    # From X to USD
    def to_usd(currency, amount)
      unless currency == 'BTC'
        amount = amount * spot_price(currency, 'BTC')
      end

      amount * coinbase_sell_price
    end

    private

    def coinbase_buy_price
      coinbase_client.buy_price.amount
    end

    def coinbase_sell_price
      coinbase_client.sell_price.amount
    end

    def spot_price(left, right)
      cryptsy_client.market_by_pair(left, right).last_trade.to_f
    end
  end # PriceService
end # CryptoTeller
