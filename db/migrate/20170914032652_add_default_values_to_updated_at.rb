class AddDefaultValuesToUpdatedAt < ActiveRecord::Migration[5.0]
  def change
  	change_column :users, :updated_at, :datetime, default: Date.today 
  	change_column :tsms, :updated_at, :datetime, default: Date.today 
  	change_column :sales_reps, :updated_at, :datetime, default: Date.today 
  	change_column :customers, :updated_at, :datetime, default: Date.today 
  	change_column :funds_banks, :updated_at, :datetime, default: Date.today 
  end
end
