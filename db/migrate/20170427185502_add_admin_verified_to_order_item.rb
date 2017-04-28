class AddAdminVerifiedToOrderItem < ActiveRecord::Migration[5.0]
  def change
  	add_column :order_items, :admin_verified, :boolean
  end
end
