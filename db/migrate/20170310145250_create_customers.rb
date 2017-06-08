class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
    	t.references 	:sales_rep
    	t.string			:company_name
    	t.string 			:contact_email
    	t.string			:phone_number
    	t.string			:address
    	t.string			:city
    	t.string			:state
    	t.string			:zipcode
      t.timestamps
    end
  end
end
