class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :validatable

  has_one :account

  before_create :build_account

  def hold(amount)
    self.balance -= amount
    self.held_balance =+ amount
  end

  def unhold(amount)
    self.balance += amount
    self.held_balance -= amount
  end
end
