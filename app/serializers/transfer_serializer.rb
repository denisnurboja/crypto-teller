class TransferSerializer < ActiveModel::Serializer
  attributes :id, :direction, :amount
  attributes :status, :note
  attributes :created_at, :updated_at
end
