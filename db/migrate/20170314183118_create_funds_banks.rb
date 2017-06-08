class CreateFundsBanks < ActiveRecord::Migration[5.0]
  def change
    create_table :funds_banks do |t|
    	t.references 	:customer
    	t.float				:marketing_allowance, default: 0.0
    	t.float				:allocated_amt, default: 0.0
      t.timestamps
    end
  end
end
