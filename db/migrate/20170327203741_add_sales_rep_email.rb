class AddSalesRepEmail < ActiveRecord::Migration[5.0]
  def change
  		add_column :sales_reps, :email, :string
  end
end
