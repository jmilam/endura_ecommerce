class ReportController < ApplicationController
	require 'csv'
	def index
	end

	def create
		start_date = Date.parse(params[:report][:start_date]).strftime("%m/%d/%Y")
		end_date = Date.parse(params[:report][:end_date]).strftime("%m/%d/%Y")

		case params[:commit].downcase
		when "fund tracking"
			@orders = Order.from_date_range(params[:report][:start_date], params[:report][:end_date]).includes(:order_items)
			@used_funds = Order.format_funds_data(@orders, Customer.all)
			@fund_bank = FundsBank.all
			@export = MySpreadsheet.new(start_date, end_date).fund_tracking(@fund_bank, @used_funds)
		when "all approved/rejected orders"
			@orders = Order.no_nil_accepted.from_date_range(params[:report][:start_date], params[:report][:end_date]).includes(:order_items).sort_by {|order| order.accepted ? 0 : 1}
			@export = MySpreadsheet.new(start_date, end_date).approved_reject(@orders, Customer.all)
		end

		send_data @export.string, filename: "#{params[:commit]}.xls", type: "application/vnd.ms-excel"
	end
end
