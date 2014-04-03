class Account < ActiveRecord::Base
  has_many :addresses
  has_many :orders
  has_many :transfers

  def hold(amount)
    self.balance -= amount
    self.held_balance += amount
  end

  def unhold(amount)
    self.balance += amount
    self.held_balance -= amount
  end
end
