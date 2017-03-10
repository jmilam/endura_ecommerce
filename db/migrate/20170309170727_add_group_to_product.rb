class AddGroupToProduct < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :group, :text
  end
end
