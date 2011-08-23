class Micropost < ActiveRecord::Base

	# eg : Micropost.new(:content=>"foobar", :user_id=>333)
	# :user_id will be ignored!
	attr_accessible :content
	
	belongs_to :user
	
	validates :content, :presence => true, :length => { :maximum => 140 }
	validates :user_id, :presence => true 
	
	default_scope :order => 'microposts.created_at DESC'
	
	scope :from_users_followed_by, lambda { |user| followed_by(user) }
	
	private
	
		# Equivalent to <==>
		# 	SELECT * FROM microposts
		# 	WHERE user_id IN (<list of ids>) OR user_id = <user id>
		#
		def self.followed_by(user)
			followed_ids = %(SELECT followed_id FROM relationships
							 WHERE follower_id = :user_id)
			where("user_id IN (#{followed_ids}) OR user_id = :user_id",
				  :user_id => user)
		end

end
