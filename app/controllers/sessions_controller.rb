class SessionsController < ApplicationController
  
	def new
		@title = "Sign in"
  	end

	# POST /sessions
	# create a new session
	def create
		user = User.authenticate(params[:session][:email],
								 params[:session][:password])
		if user.nil?
			# handle errors
			flash.now[:error] = "Invalid email/password combination."
			render 'new'
		else
			# handle successful signin
			sign_in user
			redirect_back_or user
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end

end
