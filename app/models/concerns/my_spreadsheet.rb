class MySpreadsheet
	require 'spreadsheet'

	def initialize(start_date, end_date)
		@file_contents = StringIO.new
		@start_date = start_date.empty? ? Date.today.beginning_of_week.strftime("%m/%d/%Y") : Date.parse(start_date).strftime("%m/%d/%Y")
		@end_date = end_date.empty? ? Date.today.end_of_week.strftime("%m/%d/%Y") : Date.parse(end_date).strftime("%m/%d/%Y")

		Spreadsheet.client_encoding = 'UTF-8'
		@book = Spreadsheet::Workbook.new
		@sheet1 = @book.create_worksheet
		@sheet1.row(0).concat ["Report Date Range #{@start_date} - #{@end_date}"]
		

	end

	def fund_tracking(funds_bank, used_funds)
		row_count = 1
		@sheet1.merge_cells(0,0,0,4)

		@sheet1.row(row_count).concat ["Customer", "Balance #{@start_date}", "Used Amt.", "Balance #{@end_date}", "Beginning Balance"]

		funds_bank.each do |fb|
			row_count = next_row(row_count)
			current = fb.current_bal.to_i
			used = used_funds["#{fb.customer.company_name}"].to_i
			@sheet1.row(row_count).concat ["#{fb.customer.company_name}", "$#{current}", "$" + used.to_s, "$" + (current + used).to_s, "$#{fb.allocated_amt.to_i}"]
		end

		write_to_book
	end

	def approved_reject(orders, customers)
		row_count = 1
		@sheet1.merge_cells(0,0,0,7)

		@sheet1.row(row_count).concat ["Order #", "Sales Rep", "Deadline", "Deadline Reason", "Payment Method", "Company Name", "Order Reason", "Approved"]
		
		orders.each do |o|
			row_count = next_row(row_count)
			customer = customers.find_by_id(o.customer_id)
			customer = customer.nil? ? "" : customer.company_name
			@sheet1.row(row_count).concat ["#{o.id}", "#{o.user.name}", "#{o.deadline}", "#{o.deadline_reason}", "#{o.payment_method}", "#{customer}", "#{o.order_reason}", "#{o.accepted}"]
			
			row_count = next_row(row_count)
			@sheet1.row(row_count).concat ["", "Item", "Product Type", "Item Total", "Note"]
			o.order_items.each do |item|
				row_count = next_row(row_count)
				unless Product.find_by_id(item.reference_id).nil?
					@sheet1.row(row_count).concat ["", "#{Product.find(item.reference_id).name}", "#{item.item_type}", "#{item.item_total}", "#{item.note}"]
				end
			end
		end

		write_to_book
	end

	def customers
		customers = Customer.all.includes(:sales_rep)

		row_count = 1
		@sheet1.merge_cells(0,0,0,7)

		@sheet1.row(row_count).concat ["Company Name", "Company Contact", "Contact Email", "Phone Number", "Address", "City", "State", "Zipcode", "Sales Rep", "Allocated Amount", "Current Balance"]
		
		customers.each do |customer|
			row_count = next_row(row_count)

			customer_data = customer.funds_bank.nil? ? ["#{customer.company_name}",
																									"#{customer.company_contact}",
																									"#{customer.contact_email}",
																									"#{customer.phone_number}",
																									"#{customer.address}",
																									"#{customer.city}",
																									"#{customer.state}",
																									"#{customer.zipcode}",
																									"#{customer.sales_rep.name}"] :
																									["#{customer.company_name}",
																									"#{customer.company_contact}",
																									"#{customer.contact_email}",
																									"#{customer.phone_number}",
																									"#{customer.address}",
																									"#{customer.city}",
																									"#{customer.state}",
																									"#{customer.zipcode}",
																									"#{customer.sales_rep.name}",
																									"#{customer.funds_bank.allocated_amt}",
																									"#{customer.funds_bank.current_bal}"]
			@sheet1.row(row_count).concat customer_data
		end

		write_to_book.string
	end

	def next_row(count)
		count += 1
	end

	def write_to_book
		@book.write @file_contents

		@file_contents
	end
end
