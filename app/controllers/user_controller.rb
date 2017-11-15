class UserController < ApplicationController
	def new
		@type = "user"
		@table_headers = ["Email", "Actions"]
		@data_variable = User.new
		@path = user_index_path
		@column_names = [:name, :email, :password, :admin]
		respond_to do |format|
			format.js { render :template => "/partials/new" }
		end
	end

	def create
		begin 
			admin = params[:user][:admin].nil? ? false : params[:user][:admin]

			if User.create(name: params[:user][:name],
										 email: params[:user][:email],
										 password: params[:user][:password],
										 password_confirmation: params[:user][:password],
										 admin: admin,
										 created_at: Date.today)

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
  	@table_headers = ["Email", "Password", "Admin", "Actions"]
  	@data_variable = User.all
  	@column_names = @data_variable.column_names.keep_if {|value| value == "email" }
  	@column_names << "*******"
  	@column_names << "admin"
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

	def update_admin_value
		user = User.find_by(email: params[:user_email])
		user.update(admin: params[:admin])
	end

	private

	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation, :created_at, :admin)
	end

end