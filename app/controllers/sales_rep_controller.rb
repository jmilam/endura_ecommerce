class SalesRepController < ApplicationController

	def new
		@type = "sales_rep"
		@table_headers = ["TSM", "Name", "Actions"]
		@select_box_data = Tsm.all
		@data_variable = SalesRep.new
		@path = sales_rep_index_path
		@select_id = "tsm_id"
		@column_names = @data_variable.attributes.keys.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}
		respond_to do |format|
			format.js { render :template => "/partials/new" }
		end
	end

	def create
		Tsm.find_by_id(params[:sales_rep][:tsm_id])
		@sales_rep = Tsm.find_by_id(params[:sales_rep][:tsm_id]).sales_reps.new(sales_rep_params)
		@sales_rep.created_at = Date.today
		begin
			if @sales_rep.save
				flash[:notice] = "User successfully created"
				redirect_to :back
			else
				flash[:error] = @sales_rep.errors
				redirect_to :back
			end
		rescue Exception => e
			flash[:error] = e
			redirect_to :back
		end
	end

	def update
		begin
			@tsm = Tsm.find_by_name(params[:tsm])
			if SalesRep.update(params[:id], name: params[:name], email: params[:email], rep_group: params[:rep_group], tsm_id: @tsm.id)
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

	def edit
		@type = "sales_rep"
		@rep_group = Customer.all.map {|customer| customer.rep_group}.uniq!
		@rep_group = @rep_group.delete_if {|r| r.nil?} unless @rep_group.nil?
  	@table_headers = ["TSM", "Name", "Email", "Rep Group", "Actions"]
  	@data_variable = SalesRep.all
  	@column_names = @data_variable.column_names.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}
		respond_to do |format|
			format.js { render :template => "/partials/edit" }
		end
	end
	
	def destroy
		@sales_rep = SalesRep.find(params[:id])
		if @sales_rep.delete
			redirect_to(:root)
		else
			redirect_to(:root)
		end
	end
	private

	def sales_rep_params
		params.require(:sales_rep).permit(:name, :email, :rep_group, :created_at, :updated_at)
	end
end