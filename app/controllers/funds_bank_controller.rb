class FundsBankController < ApplicationController
	def new
		@type = "funds_bank"
		#@table_headers = ["Name", "Actions"]
		@data_variable = FundsBank.new
		@path = funds_bank_index_path
		@select_box_data = Customer.all.sort
		@select_id = "customer_id"
		@column_names = @data_variable.attributes.keys.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}
		respond_to do |format|
			format.js { render :template => "/partials/new" }
		end
	end

	def create
		@customer = Customer.find(params[:funds_bank][:customer_id])
		@funds_bank = @customer.build_funds_bank(funds_bank_params)

		if @funds_bank.save
			flash[:notice] = "Customer successfully received funds"
			redirect_to :back
		else
			flash[:error] = @funds_bank.errors
			redirect_to :back
		end
	end

	def edit
		@type = "funds_bank"
		@table_headers = ["Customer", "Marketing Allowance", "Allocated Amt.", "Actions"]
		@data_variable = FundsBank.all.includes(:customer)
		@column_names = @data_variable.column_names.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}
		respond_to do |format|
			format.js { render :template => "/partials/edit" }
		end
	end

	def update
		begin
			@customer = Customer.find_by_company_name(params[:customer_name])
			if FundsBank.update(params[:id], marketing_allowance: params[:marketing_allowance], allocated_amt: params[:allocated_amt], customer_id: @customer.id)
				@response = {response: {success: true}}
			else
				"Not saved"
			end
		rescue Exception => error
			@response = {response: {success: false, error: "#{error}"}}
		end

		respond_to do |format|
			format.json { render json: @response}
		end
	end

	private

	def funds_bank_params
		params.require(:funds_bank).permit(:customer_id, :marketing_allowance, :allocated_amt)
	end
end