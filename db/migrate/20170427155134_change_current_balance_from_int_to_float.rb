class ChangeCurrentBalanceFromIntToFloat < ActiveRecord::Migration[5.0]
  def change
  	change_column :funds_banks, :current_bal, :float, default: 0.0 
  end
end
