class CreateProductConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :product_configurations do |t|
    	t.integer :order_item_id
    	t.integer :sub_product_id
    	t.integer :product_finish_id
    	t.string :sub_finish_id

      t.timestamps
    end
    add_index :product_configurations, :order_item_id
  end
end
