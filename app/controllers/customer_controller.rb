class CustomerController < ApplicationController
	def new
		@customer = Customer.new
		@select_box_data = SalesRep.all
		
		respond_to do |format|
			format.html
		end
	end

	def create
		begin
			@sales_rep = SalesRep.find(params[:customer][:rep_group])
			@customer = Customer.new(customer_params)
			@customer.rep_group = @sales_rep.rep_group
			@customer.created_at = Date.today

			if @customer.save
				@funds = @customer.association(:funds_bank).build(allocated_amt: params[:customer][:allocated_amt],
																								 					current_bal: params[:customer][:funds_balance])

				if @funds.save
					flash[:notice] = "Customer successfully created"
					redirect_to user_portal_index_path
				end
			else

				flash[:error] = @customer.errors
				redirect_to new_customer_path
			end
		rescue Exception => e
			flash[:error] = e
			redirect_to new_customer_path
		end
	end

	def show
		@customer = Customer.find_by_company_name(params[:company_name])

		@result = Hash.new
		@result[:customer] = @customer
		
		respond_to do |format|
			format.html
			format.json {render json: @result}
		end
	end

	def edit
		if params[:id] != "0"
			@customer = Customer.find(params[:id])
		end

		@select_box_data = SalesRep.all
		@type = "customer"
		@rep_group = Customer.all.map {|customer| customer.rep_group}.uniq!
		@rep_group = @rep_group.delete_if {|r| r.nil?} unless @rep_group.nil?
		@table_headers = ["Company Name", "Contact Email", "Phone Number", "Address", "City", "State", "Zipcode", "Company Contact", "Rep Group", "Funds Current Balance", "Funds Allocated Amt.", "Actions"]
		@data_variable = Customer.all.order 'rep_group ASC'
		@column_names = @data_variable.column_names.delete_if {|value| value == "created_at" ||
																														value == "updated_at" ||
																														value == "id" ||
																														value == "funds_balance"}
		@column_names << "funds_balance"

		respond_to do |format|
			format.html
			format.js { render :template => "/partials/edit" }
		end
	end

	def update
		Customer.transaction do 
			begin
				rep = SalesRep.find(params[:customer][:rep_group])
				@customer = Customer.find(params[:id])
				if @customer.update(customer_params)
					@customer.update(rep_group: rep.rep_group)
					@customer.funds_bank.update(allocated_amt: params[:customer][:allocated_amt],
																			current_bal: params[:customer][:funds_balance])
					@response = {response: {success: true}}
				else
					@response = {response: {success: false, error: "#{@customer.errors}"}}
				end
			rescue Exception => error
				@response = {response: {success: false, error: "#{error}"}}
			end
		end

		respond_to do |format|
			format.html { redirect_to user_portal_index_path}
			format.json { render json: @response}
		end
	end

	def destroy
		@customer = Customer.find(params[:id])
		if @customer.delete
			redirect_to(:root)
		else
			redirect_to(:root)
		end
	end

	private

	def customer_params
		params.require(:customer).permit(:company_name, :contact_email, :phone_number, :address, :city, :state, :zipcode, :created_at, :company_contact, :rep_group)
	end

end