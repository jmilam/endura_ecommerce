class CreateCatalogRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :catalog_requests do |t|
    	t.date   			:date
    	t.date   			:deadline
    	t.string 			:sales_rep
    	t.string 			:tsm
    	t.string 			:company_name
    	t.string 			:company_contact
    	t.string 			:email
    	t.string 			:phone_number
    	t.string 			:ship_address
    	t.string 			:city
    	t.string 			:sate
    	t.string 			:zipcode
    	t.string 			:produced_by
    	t.integer			:page_count
    	t.string 			:endura_intro
    	t.string 			:z_cap_sill
    	t.string 			:trilennium_multi_point
    	t.string 			:multi_point_astragal
    	t.string 			:ultimate_astragal
    	t.string 			:flip_lever_astragal
    	t.string 			:framesaver
    	t.string 			:weathersealing
    	t.string 			:other
    	t.text   			:other_desc
    	t.binary 			:file_1
    	t.binary 			:file_2
      t.timestamps
    end
  end
end
