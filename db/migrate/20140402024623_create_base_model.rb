class CreateBaseModel < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.decimal :balance,      default: 0
      t.decimal :held_balance, default: 0

      t.references :user

      t.timestamps
    end

    create_table :addresses do |t|
      t.string :address
      t.string :label
      t.string :currency

      t.references :account

      t.timestamps
    end

    create_table :orders do |t|
      t.string :direction
      t.decimal :amount

      t.string :status
      t.string :note

      t.string :address
      t.string :currency
      t.string :transaction_id

      t.references :account

      t.timestamps
    end

    create_table :transfers do |t|
      t.string :direction
      t.decimal :amount

      t.string :status
      t.string :note

      t.references :account

      t.timestamps
    end
  end
end
