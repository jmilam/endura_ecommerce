class ImportTsmAssociationData
	require 'spreadsheet'

	def import
		ActiveRecord::Base.transaction do
			begin
				book = Spreadsheet.open('/home/itadmin/marketing_user_import.xls')
				data = book.worksheet(0)
			  
			  tsm = false
			  rep = false
			  companies = false

			  data.each do |row|
			  	unless row[0].nil?
					  if row[0].downcase == "tsm"
						  tsm = true
						  rep = false
						  companies = false
					  elsif row[0].downcase == "sales rep"
						  tsm = false
						  companies = false
						  rep = true
					  elsif row[0].downcase == "companies"
						  rep = false
						  tsm = false
						  companies = true
						elsif tsm
						  Tsm.create(name: row[0], email: row[1])
						  create_user(row[0], row[1], 'EnduraTSM1')
						elsif rep
						  Tsm.last.sales_reps.create(name: row[0], email: row[1], rep_group: row[2])
						  create_user(row[0], row[1], 'Endura1234')
						elsif companies
						  rep_group = SalesRep.last.rep_group
						  unless row[0].downcase == "company name"
							  customer = SalesRep.last.customers.create(company_name: row[0],
							  																					contact_email: row[2],
							  																					phone_number: row[4],
							  																					address: row[5],
							  																					city: row[6],
							  																					state: row[7],
							  																					zipcode: row[8].to_i,
							  																					company_contact: row[1],
							  																					rep_group: row[3])

							  FundsBank.create(customer_id: customer.id, allocated_amt: row[9], current_bal: row[10])
							 end
				  	end
				  end
				end
			rescue Exception => e
			  p e
			end
		end
	end

	def create_user(name, email, password)
		user = User.find_by_email(email)

		if user.nil?
			User.create(name: name, email: email, password: password)
		end
	end
end
