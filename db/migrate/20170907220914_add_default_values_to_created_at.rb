class AddDefaultValuesToCreatedAt < ActiveRecord::Migration[5.0]
  def change
  	change_column :users, :created_at, :datetime, default: Date.today 
  	change_column :tsms, :created_at, :datetime, default: Date.today 
  	change_column :sales_reps, :created_at, :datetime, default: Date.today 
  	change_column :customers, :created_at, :datetime, default: Date.today 
  	change_column :funds_banks, :created_at, :datetime, default: Date.today 
  end
end
