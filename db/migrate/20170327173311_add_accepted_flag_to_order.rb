class AddAcceptedFlagToOrder < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :accepted, :boolean
  end
end
