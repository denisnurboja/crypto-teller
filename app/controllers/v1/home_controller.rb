class V1::HomeController < ApplicationController
  def index
    render json: {
      account_url: account_url,
      account_addresses_url: account_addresses_url,
      user_url: user_url
    }
  end
end
