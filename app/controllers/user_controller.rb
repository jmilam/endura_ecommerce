class UserController < ApplicationController
	def index
		@users = User.all
	end

	def new
		@user = User.new

		respond_to do |format|
			format.html
		end
	end

	def create
		begin 
			admin = params[:user][:admin].nil? ? false : params[:user][:admin]

			@user = User.new(user_params)

			if @user.save!
				flash[:notice] = "User successfully created"
				redirect_to root_path
			else
				flash[:error] = @user.errors
				render action: 'new'
			end
		rescue Exception => e
			flash[:error] = e
			redirect_to new_user_path
		end
	end

	def update
		if params[:user][:password].empty?
			updated = User.update(params[:id], name: params[:user][:name], email: params[:user][:email], admin: params[:user][:admin])
		else
			updated = User.update(params[:id], name: params[:user][:name], email: params[:user][:email], password: params[:user][:password], password_confirmation: params[:user][:password])
		end

		if updated
			flash[:notice] = "User successfully updated."
			redirect_to user_index_path
		else
			flash[:error] = "There was an error udpating this user. Please try again."
			render :edit
		end

	end

	def edit
		@user = User.find(params[:id])

		respond_to do |format|
			format.html
		end
	end
	
	def destroy
		@user = User.find(params[:id])

		if @user.delete
			flash[:notice] = "User successfully deleted."
		else
			flash[:error] = @user.errors
		end

		redirect_to user_index_path
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