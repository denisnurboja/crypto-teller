class V1::PricesController < ApplicationController
  # GET /prices/buy
  def buy
    currency = params.require(:currency).upcase
    quantity = params.fetch(:quantity, 1).to_f

    result = price_service.from_usd(currency, quantity)

    render json: {
      amount: result.round(8),
      currency: currency
    }
  end

  # GET /prices/sell
  def sell
    currency = params.require(:currency).upcase
    quantity = params.fetch(:quantity, 1).to_f

    result = price_service.to_usd(currency, quantity)

    render json: {
      amount: result.round(2),
      currency: 'USD'
    }
  end

  private

  def price_service
    CryptoTeller.price_service
  end
end
