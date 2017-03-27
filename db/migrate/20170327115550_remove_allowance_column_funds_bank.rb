class RemoveAllowanceColumnFundsBank < ActiveRecord::Migration[5.0]
  def change
  	remove_column :funds_banks, :marketing_allowance
  end
end
