class AccountSerializer < ActiveModel::Serializer
  attributes :balance, :held_balance
end
