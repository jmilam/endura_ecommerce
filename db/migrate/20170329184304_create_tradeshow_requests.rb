class CreateTradeshowRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :tradeshow_requests do |t|
    	t.string			:first_name
    	t.string			:last_name
    	t.string			:phone_number
    	t.string			:email
    	t.string			:show_name
    	t.date				:start_date
    	t.date 				:end_date
    	t.string			:address
    	t.string			:city
    	t.string			:state
    	t.string			:zipcode
    	t.string			:booth_num
    	t.string			:booth_dimensions
    	t.string			:show_size
    	t.string			:target_market
    	t.boolean			:z_cap_sill, default: false
    	t.boolean			:ada_sills, default: false
    	t.boolean			:zai_sills, default: false
    	t.boolean			:trilennium_multi_point_locking, default: false
    	t.boolean			:multi_point_astragal, default: false
    	t.boolean			:ultimate_astragal, default: false
    	t.boolean			:ultimate_flip_lever_astragal, default: false
    	t.boolean			:framesaver, default: false
    	t.boolean			:weathersealing, default: false
    	t.integer			:number_of_attendees, default: 0
    	t.boolean			:registration_assistance, default: false
    	t.boolean			:credit_issued, default: false
    	t.binary 			:attendee_list
    	t.binary 			:credit_documentation
      t.timestamps
    end
  end
end
