class AddCommentFieldToOrderItem < ActiveRecord::Migration[5.0]
  def change
  	add_column :order_items, :note, :string
  end
end
