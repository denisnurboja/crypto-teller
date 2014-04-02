module CryptoTeller
  class GmailAdapter
    def initialize(username, password, from)
      @client = Gmail.connect!(username, password)
      @from = from
    end

    def call
      @client.inbox.find(:unread, from: @from).each do |email|
        yield email.message.body
      end
    end

    def logout
      @client.logout
    end
  end
end
