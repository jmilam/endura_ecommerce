class CreateProductFinishes < ActiveRecord::Migration[5.0]
  def change
    create_table :product_finishes do |t|
    	t.integer :sub_product_id
    	t.string	:name
      t.timestamps
    end
    add_index :product_finishes, :sub_product_id
  end
end
