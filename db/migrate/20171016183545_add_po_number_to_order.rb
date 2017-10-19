class AddPoNumberToOrder < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :po_number, :string, default: ""
  end
end
