class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
    	t.integer		:order_id
    	t.string		:item_type
    	t.integer		:reference_id
    	t.integer		:quantity
      t.timestamps
    end
  end
end
