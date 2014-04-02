require 'cryptsy/web_client'
require 'crypto_teller/gmail_adapter'
require 'crypto_teller/price_service'

module CryptoTeller
  extend self

  CRYPTSY_SUPPORT_EMAIL = 'support@cryptsy.com'

  attr_writer :cryptsy_client
  attr_writer :cryptsy_web_client
  attr_writer :coinbase_client

  def cryptsy_client
    unless @cryptsy_client
      @cryptsy_client = Cryptsy::Client.new(
        ENV['CRYPTSY_PUBKEY'],
        ENV['CRYPTSY_PRIVKEY']
      )
    end

    @cryptsy_client
  end

  def cryptsy_web_client
    unless @cryptsy_web_client
      @cryptsy_web_client = Cryptsy::WebClient.new(
        ENV['CRYPTSY_USERNAME'],
        ENV['CRYPTSY_PASSWORD'],
        ENV['CRYPTSY_TFA_SECRET']
      )
    end

    @cryptsy_web_client
  end

  def coinbase_client
    unless @coinbase_client
      @coinbase_client = Coinbase::Client.new(
        ENV['COINBASE_API_KEY'],
        ENV['COINBASE_API_SECRET']
      )
    end

    @coinbase_client
  end

  def price_service
    unless @price_service
      @price_service = PriceService.new
      @price_service.coinbase_client = coinbase_client
      @price_service.cryptsy_client = cryptsy_client
      @price_service.cache = Rails.cache
    end

    @price_service
  end

  def gmail_adapter
    GmailAdapter.new(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'], CRYPTSY_SUPPORT_EMAIL)
  end
end