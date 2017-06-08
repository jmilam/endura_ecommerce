class AddRepGroupToCustomers < ActiveRecord::Migration[5.0]
  def change
  	add_column :customers, :rep_group, :string
  	add_column :sales_reps, :rep_group, :string
  end
end
