class AddItemNumberToProductAndImage < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :item_number, :string, default: ''
  	add_column :images, :item_number, :string, default: ''
  end
end
