class CustomerController < ApplicationController
	def new
		@type = "customer"
		#@table_headers = ["Email", "Actions"]
		@data_variable = Customer.new
		@path = customer_index_path
		@select_box_data = SalesRep.all
		@select_id = "sales_rep_id"
		@column_names = [:sales_rep_id, :company_contact, :company_name, :contact_email, :phone_number, :address, :city, :state, :zipcode]
		respond_to do |format|
			format.js { render :template => "/partials/new" }
		end
	end

	def create
		@sales_rep = SalesRep.find_by_id(params[:customer][:sales_rep_id])
		@customer = @sales_rep.customers.new(customer_params)
		@customer.created_at = Date.today
		p @customer
		begin
			if @customer.save
				flash[:notice] = "Customer successfully created"
				redirect_to :back
			else

				flash[:error] = @customer.errors
				redirect_to :back
			end
		rescue Exception => e
			flash[:error] = e
			redirect_to :back
		end
	end

	def update
		begin
			@rep = SalesRep.find_by_name(params[:sales_rep])
			if Customer.update(params[:id], company_name: params[:company_name], contact_email: params[:contact_email], phone_number: params[:phone_number], address: params[:address], city: params[:city], state: params[:state], zipcode: params[:zipcode], sales_rep_id: @rep.id)
				@response = {response: {success: true}}
			else
				"Not saved"
			end
		rescue Exception => error
			@response = {response: {success: false, error: "#{error}"}}
		end

		respond_to do |format|
			format.html { redirect_to user_portal_index_path}
			format.json { render json: @response}
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
		@type = "customer"
		@table_headers = ["Sales Rep", "Company Name", "Contact Email", "Phone Number", "Address", "City", "State", "Zipcode", "Company Contact", "Actions"]
		@data_variable = Customer.all
		@column_names = @data_variable.column_names.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}
		respond_to do |format|
			format.js { render :template => "/partials/edit" }
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
		params.require(:customer).permit(:company_name, :contact_email, :phone_number, :address, :city, :state, :zipcode, :created_at, :sales_rep_id, :company_contact)
	end

end