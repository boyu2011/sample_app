class UsersController < ApplicationController

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
			redirect_to user_path(@user), :flash => { :success => "Welcome to the Sample App!"}
		else 
			@title = "Sign up"
			render 'new'
		end
	end

end
