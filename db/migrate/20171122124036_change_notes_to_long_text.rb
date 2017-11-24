class ChangeNotesToLongText < ActiveRecord::Migration[5.0]
  def change
  	change_column :order_items, :note, :text
  	change_column :orders, :deadline_reason, :text
  	change_column :orders, :payment_method, :string
  end
end
