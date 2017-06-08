class AddDefaultsToOrder < ActiveRecord::Migration[5.0]
  def change
  	remove_column :orders, :current_order
  	remove_column :orders, :order_complete
  	add_column :orders, :current_order, :boolean, default: false
  	add_column :orders, :order_complete, :boolean, default: false
  end
end
