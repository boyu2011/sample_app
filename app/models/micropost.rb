class Micropost < ActiveRecord::Base

	# eg : Micropost.new(:content=>"foobar", :user_id=>333)
	# :user_id will be ignored!
	attr_accessible :content
	
	belongs_to :user
	
	default_scope :order => 'microposts.created_at DESC'
	
end
