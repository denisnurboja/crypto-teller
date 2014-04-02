class AddTxIndexToOrders < ActiveRecord::Migration
  def change
    add_index :orders, :transaction_id, unique: true
  end
end
