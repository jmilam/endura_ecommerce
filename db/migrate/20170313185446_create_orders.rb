class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
    	t.integer :user_id
    	t.boolean :current_order
    	t.boolean :order_complete
      t.timestamps
    end
  end
end
