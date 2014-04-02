class Order < ActiveRecord::Base
  belongs_to :account

  def buy?
    direction == 'buy'
  end

  def sell?
    direction == 'sell'
  end
end
