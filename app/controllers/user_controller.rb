class UserController < ApplicationController
	def new
		@type = "user"
		@table_headers = ["Email", "Actions"]
		@data_variable = User.new
		@path = user_index_path
		@column_names = [:email, :password, :password_confirmation, :admin]
		respond_to do |format|
			format.js { render :template => "/partials/new" }
		end
	end

	def create
		@user = User.new(user_params)
		@user.created_at = Date.today
		begin
			if @user.save
				flash[:notice] = "User successfully created"
				redirect_to :back
			else
				flash[:error] = @user.errors
				redirect_to :back
			end
		rescue Exception => e
			flash[:error] = e
			redirect_to :back
		end
	end

	def update
		begin
			if params[:password].empty?
				updated = User.update(params[:id], email: params[:email])
			else
				updated = User.update(params[:id], email: params[:email], password: params[:password], password_confirmation: params[:password])
			end

			if updated
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
		@type = "user"
  	@table_headers = ["Email", "Password", "Actions"]
  	@data_variable = User.all
  	@column_names = @data_variable.column_names.keep_if {|value| value == "email" }
  	@column_names << "*******"
		respond_to do |format|
			format.js { render :template => "/partials/edit" }
		end
	end
	
	def destroy
		@user = User.find(params[:id])

		if @user.delete
			redirect_to(:root)
		else
			redirect_to(:root)
		end
	end

	private

	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation, :name, :checkbox, :created_at, :admin)
	end

end