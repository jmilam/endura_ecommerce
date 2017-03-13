class CreateImageRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :image_requests do |t|
    	t.date   			:date
    	t.date   			:deadline
    	t.string 			:sales_rep
    	t.string 			:tsm
    	t.string 			:company_name
    	t.string 			:company_contact
    	t.string 			:email
    	t.string 			:phone_number
    	t.string 			:request_purpose
    	t.text	 			:other_entry
    	t.integer 		    :total_number_images
    	t.text   			:images_needed
    	t.string			:file_format
    	t.binary 			:file_1
    	t.binary 			:file_2
      t.timestamps
      t.timestamps
    end
  end
end
