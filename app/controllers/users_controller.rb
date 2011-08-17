class UsersController < ApplicationController

	before_filter :authenticate, :only => [:edit, :update]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => :destroy

	# GET "users"
	def index
		@users = User.paginate(:page => params[:page])
		@title = "All users"
	end


	# GET "users/new" ("/signup")
	def new
		@user = User.new
		@title = "Sign up"
	end

	# GET "users/id"
	def show
		@user = User.find(params[:id])
		@title = @user.name
	end

	# POST "users/"
	def create
		@user = User.new(params[:user])
		if @user.save
			# handle a successful save.
			sign_in @user
			redirect_to user_path(@user), :flash => { :success => "Welcome to the Sample App!"}
		else 
			@title = "Sign up"
			render 'new'
		end
	end

	# GET "users/id/edit"
	def edit
		# this sentence is an option because it was called by before_filter :correct_user
		#@user = User.find(params[:id])
		@title = "Edit user"
	end

	def update
		# this sentence is an option because it was called by before_filter :correct_user
		#@user = User.find(params[:id])

		if @user.update_attributes(params[:user])
			# it worked
			redirect_to @user, :flash => { :success => "Profile updated"}
		else
			@title = "Edit user"
			render 'edit'
		end
	end
	
	def destroy
		User.find(params[:id]).destroy
		redirect_to users_path, :flash => { :success => "user destroyed."}
		
	end

	private

		def authenticate
			deny_access unless signed_in?
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to (root_path) unless @user == current_user
		end
		
		def admin_user
			user = User.find(params[:id])
			redirect_to(root_path) unless current_user.admin?
		end
end




