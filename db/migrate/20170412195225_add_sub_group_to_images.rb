class AddSubGroupToImages < ActiveRecord::Migration[5.0]
  def change
  	add_column :images, :sub_group, :string
  end
end
