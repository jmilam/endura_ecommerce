class CreateSubProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_products do |t|
    	t.integer :product_id
    	t.string :name
      t.timestamps
    end
    add_index :sub_products, :product_id
  end
end
