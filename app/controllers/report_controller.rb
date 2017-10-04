class ReportController < ApplicationController
	def index
	end

	def show
		begin
			admin = current_user.admin
			@fund_summary = Array.new
			@title = params[:commit].gsub("_", " ").titlecase
			@report_type = params[:commit]
			@start_date = params[:report][:start_date].empty? ? Date.today.beginning_of_month.strftime("%Y-%m-%d") : params[:report][:start_date]
			@end_date = params[:report][:end_date].empty? ? Date.today.end_of_month.strftime("%Y-%m-%d") : params[:report][:end_date]
			@formatter = Formatter.new

			case params[:commit].downcase
			when "all_approved/rejected_orders"
				@orders = admin ? Order.no_nil_accepted.from_date_range(@start_date, @end_date).includes(:order_items).sort_by {|order| order.accepted ? 0 : 1} : Order.no_nil_accepted.from_date_range(@start_date, @end_date).includes(:order_items).individual(current_user.id).sort_by {|order| order.accepted ? 0 : 1}
				@results = @orders
			when 'export_customer_details'
				@results = Customer.all
			when 'catalog_requests_approved'
			  @results = CatalogRequest.from_date_range(@start_date, @end_date)
			when 'tradeshow_requests_approved'
				@results = TradeshowRequest.from_date_range(@start_date, @end_date)
			when 'funds_details_by_customer'
				@customer_chart_data = Array.new
				@orders = admin ? Order.from_date_range(@start_date, @end_date).includes(:order_items) : Order.from_date_range(@start_date, @end_date).includes(:order_items).individual(current_user.id)
				@customers = Customer.all
				FundsBank.calculate_used(@orders).keys.each do |customer_id|
					funds = FundsBank.find_by_customer_id(customer_id)
					@fund_summary << funds

					if funds.nil?
						@customer_chart_data << [
														          ['Task', 'Hours per Day'],
														          ['Used Amt',   0],
														          ['Available Amt',     0]
														        ]
					else
						@customer_chart_data << [
														          ['Task', 'Hours per Day'],
														          ['Used Amt',   (funds.allocated_amt - funds.current_bal).abs],
														          ['Available Amt',     funds.current_bal]
														        ]
					end
				end
				@results = @customers
			when 'image_requests_approved'
				approved_images = Array.new
				images = OrderItem.from_date_range(@start_date, @end_date).includes(:order).images
				images.each do |image|
					approved_images << image if image.order.accepted
				end
				@results = approved_images
			else
			end
			
			@column_count = @results.first.attributes.count + 1

			respond_to do |format|
	  		format.html
	  		format.js
	  	end
		rescue => error
			{response: {error: "#{error}"}}
		end
	end

	def create
		begin
			@export = MySpreadsheet.new(params[:start_date], params[:end_date])
			case params[:report_type].downcase
			# when "fund_tracking"
			# 	@orders = Order.from_date_range(params[:start_date], params[:end_date]).includes(:order_items)
			# 	@used_funds = Order.format_funds_data(@orders, Customer.all)
			# 	@fund_bank = FundsBank.all
			# 	@export = @export.fund_tracking(@fund_bank, @used_funds).string
			# 	send_data @export, filename: "#{params[:report_type]}.xls", type: "application/vnd.ms-excel"
			when "all_approved/rejected_orders"
				@orders = Order.no_nil_accepted.from_date_range(params[:start_date], params[:end_date]).includes(:order_items).sort_by {|order| order.accepted ? 0 : 1}
				@export = @export.approved_reject(@orders, Customer.all).string
				send_data @export, filename: "#{params[:report_type]}.xls", type: "application/vnd.ms-excel"
			when 'export_customer_details'
				@export = @export.customers
				send_data @export, filename: "#{params[:report_type]}.xls", type: "application/vnd.ms-excel"
			when 'catalog_requests_approved'
			  @export = Pdf.new
				send_data @export.catalog_requests(CatalogRequest.from_date_range(params[:start_date], params[:end_date])).render, type: "application/pdf"
			when 'tradeshow_requests_approved'
				@export = Pdf.new
				send_data @export.tradeshow_requests(TradeshowRequest.from_date_range(params[:start_date], params[:end_date])).render, type: "application/pdf"
			when 'funds_details_by_customer'
				customers = Customer.all
				orders = Order.from_date_range(params[:start_date], params[:end_date]).includes(:order_items)
				@funds_summary = FundsBank.calculate_used(orders)
			when 'image_requests_approved'
				@export = Pdf.new

				send_data @export.image_requests(OrderItem.from_date_range(params[:start_date], params[:end_date]).includes(:order).images).render, type: "application/pdf"
			else
			end
		rescue => error
			p error
		end
	end
end
