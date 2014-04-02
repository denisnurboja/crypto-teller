class OrderSerializer < ActiveModel::Serializer
  attributes :id, :direction, :amount
  attributes :address, :currency, :transaction_id
  attributes :status, :note
  attributes :created_at, :updated_at
end
