class AddOrderReceipient < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :order_receipient, :string, default: ''
  end
end
