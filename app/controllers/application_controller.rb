class ApplicationController < ActionController::Base
  protect_from_forgery

	# For access signed_in? from sessions_helper.rb
	include SessionsHelper

end
