class AddStatusToOrder < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :order_status_id, :integer, default: 1
  end
end
