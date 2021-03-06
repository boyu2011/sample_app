class User < ActiveRecord::Base

	# just stored in the memory
	attr_accessor :password
	# must have???
	attr_accessible :name, :email, :password, :password_confirmation
	
	has_many :microposts, 	         :dependent => :destroy
	
	has_many :relationships,         :dependent => :destroy,
							         :foreign_key => "follower_id"
    
    has_many :reverse_relationships, :dependent => :destroy,
                                     :foreign_key => "followed_id",
                                     :class_name => "Relationship"
    
    has_many :following,             :through =>  :relationships,
                                     :source => :followed
    
    has_many :followers,             :through => :reverse_relationships,
                                     :source => :follower


	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name,     :presence => true,
					     :length => { :maximum => 50 }
	validates :email,    :presence => true,
					     :format 	=> { :with => email_regex },
					     :uniqueness => { :case_sensitive => false }
	validates :password, :presence => true,
						 :confirmation => true,
						 :length => { :within => 6..40 }

	before_save :encrypt_password
	
	# User.admin
	#scope :admin, where(:admin => true)

	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end
	
	# User.first.feed
	# ==>
	# SELECT "microposts".* FROM "microposts" WHERE (user_id IN (SELECT followed_id FROM relationships 
	#	WHERE follower_id = 1) OR user_id = 1) ORDER BY microposts.created_at DESC
	def feed
		Micropost.from_users_followed_by(self)
	end
	
	def following?(followed)
	  self.relationships.find_by_followed_id(followed)
    end
  
    def follow!(followed)
        relationships.create!(:followed_id => followed.id)
    end

    def unfollow!(followed)
        relationships.find_by_followed_id(followed).destroy
    end

	# Usage : User.authenticate
	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
		# or
		# (user && user.has_password?(submitted_password)) ? user : nil
	end

	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end
	
	private
	
		def encrypt_password
			# new_record? will return true if the object has not yet been saved to the database
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end

		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)		
		end
end












