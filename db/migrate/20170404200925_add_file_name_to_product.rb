class AddFileNameToProduct < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :file_name, :string
  end
end
