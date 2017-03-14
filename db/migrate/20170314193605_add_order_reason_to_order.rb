class AddOrderReasonToOrder < ActiveRecord::Migration[5.0]
  def change
  		add_column :orders, :order_reason, :text
  end
end
