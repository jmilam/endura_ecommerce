class RenameColumnOrderToCustomerId < ActiveRecord::Migration[5.0]
  def change
  	rename_column :orders, :company_id, :customer_id
  end
end
