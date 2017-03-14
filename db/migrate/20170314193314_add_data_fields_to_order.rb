class AddDataFieldsToOrder < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :deadline, :date
  	add_column :orders, :deadline_reason, :string
  	add_column :orders, :payment_method, :text
  	add_column :orders, :company_id, :integer
  end
end
