class Account < ActiveRecord::Base
  has_many :addresses
  has_many :orders
  has_many :transfers
end
