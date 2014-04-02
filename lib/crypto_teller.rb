require 'cryptsy/web_client'
require 'crypto_teller/gmail_adapter'

module CryptoTeller
  extend self

  CRYPTSY_SUPPORT_EMAIL = 'support@cryptsy.com'

  attr_writer :cryptsy_client
  attr_writer :cryptsy_web_client

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

  def gmail_adapter
    GmailAdapter.new(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'], CRYPTSY_SUPPORT_EMAIL)
  end
end
