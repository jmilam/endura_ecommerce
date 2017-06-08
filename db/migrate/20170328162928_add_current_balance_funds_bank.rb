class AddCurrentBalanceFundsBank < ActiveRecord::Migration[5.0]
  def change
  	add_column :funds_banks, :current_bal, :integer, default: 0
  end
end
