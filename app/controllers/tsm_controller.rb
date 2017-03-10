class TsmController < ApplicationController
	def new
		@type = "tsm"
		@table_headers = ["Name", "Actions"]
		@data_variable = Tsm.new
		@column_names = @data_variable.attributes.keys.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}
		respond_to do |format|
			format.js
		end
	end

	def create
		@tsm = Tsm.new(tsm_params)
		if @tsm.save
			flash[:notice] = "TSM successfully created"
			redirect_to :back
		else
			#flash[:error] = "Error when creating TSM"
			#redirect_to :back
		end
	end

  def edit
  	@type = "tsm"
  	@table_headers = ["Name", "Actions"]
  	@data_variable = Tsm.all
  	@column_names = @data_variable.column_names.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}
		respond_to do |format|
			format.js
		end
  end

  def update
  	begin
			if Tsm.update(params[:id], name: params[:name])
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

  def destroy
  	@tsm = Tsm.find(params[:id])

		if @tsm.delete
			redirect_to(:root)
		else
			redirect_to(:root)
		end
	end

  private

  def tsm_params
  	params.require(:tsm).permit(:name)
  end
end
