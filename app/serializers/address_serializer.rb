class AddressSerializer < ActiveModel::Serializer
  attributes :address, :currency, :label, :created_at
end
