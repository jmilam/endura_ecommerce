class AddCustomerContactCompany < ActiveRecord::Migration[5.0]
  def change
  	add_column :customers, :company_contact, :text
  end
end
