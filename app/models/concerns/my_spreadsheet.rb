class MySpreadsheet
	require 'spreadsheet'

	def initialize(start_date, end_date)
		@file_contents = StringIO.new
		@start_date = start_date
		@end_date = end_date

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


		@book.write @file_contents
		@file_contents
	end

	def approved_reject(orders, customers)
		row_count = 1
		@sheet1.merge_cells(0,0,0,7)

		@sheet1.row(row_count).concat ["Order #", "Sales Rep", "Deadline", "Deadline Reason", "Payment Method", "Company Name", "Order Reason", "Approved"]
		
		orders.each do |o|
			row_count = next_row(row_count)
			customer = customers.find_by_id(o.company_id)
			customer = customer.nil? ? "" : customer.company_name
			@sheet1.row(row_count).concat ["#{o.id}", "#{o.user.name}", "#{o.deadline}", "#{o.deadline_reason}", "#{o.payment_method}", "#{customer}", "#{o.order_reason}", "#{o.accepted}"]
		end

		@book.write @file_contents
		@file_contents
	end

	def next_row(count)
		count += 1
	end
end
