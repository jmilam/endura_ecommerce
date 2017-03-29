class ReportController < ApplicationController
	def index
	end

	def create
		begin
			@export = MySpreadsheet.new(params[:report][:start_date], params[:report][:end_date])
			
			case params[:commit].downcase
			when "fund tracking"
				@orders = Order.from_date_range(params[:report][:start_date], params[:report][:end_date]).includes(:order_items)
				@used_funds = Order.format_funds_data(@orders, Customer.all)
				@fund_bank = FundsBank.all
				@export = @export.fund_tracking(@fund_bank, @used_funds).string
				send_data @export, filename: "#{params[:commit]}.xls", type: "application/vnd.ms-excel"
			when "all approved/rejected orders"
				@orders = Order.no_nil_accepted.from_date_range(params[:report][:start_date], params[:report][:end_date]).includes(:order_items).sort_by {|order| order.accepted ? 0 : 1}
				@export = @export.approved_reject(@orders, Customer.all).string
				send_data @export, filename: "#{params[:commit]}.xls", type: "application/vnd.ms-excel"
			when 'export customer details'
				@export = @export.customers
				send_data @export, filename: "#{params[:commit]}.xls", type: "application/vnd.ms-excel"
			when 'catalog requests'
			  @export = Pdf.new
				send_data @export.catalog_requests(CatalogRequest.from_date_range(params[:report][:start_date], params[:report][:end_date])).render, type: "application/pdf"
			when 'image requests'
				@export = Pdf.new
				send_data @export.image_requests(ImageRequest.from_date_range(params[:report][:start_date], params[:report][:end_date])).render, type: "application/pdf"
			end

		rescue => error
			p error
		end
	end
end
