class AddItemTotalToOrderItem < ActiveRecord::Migration[5.0]
  def change
  	add_column :order_items, :item_total, :float, default: 0.0
  end
end
