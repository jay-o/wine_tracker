# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#

class User < ActiveRecord::Base
 	attr_accessible :email, :first_name, :last_name, :password, :password_confirmation
 	has_secure_password
 	has_many :posts, dependent: :destroy
  has_many :user_wines
  has_many :wines, through: :user_wines

	before_save { self.email.downcase! }
	before_save :create_remember_token
	
 	validates :first_name, presence: true, length: { maximum: 50 }
 	validates :last_name, presence: true, length: { maximum: 50 }
 	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, 	presence: true, 
  						format: { with: VALID_EMAIL_REGEX }, 
  						uniqueness: { case_sensitive: false }
  	validates :password, presence: true, length: { minimum: 6 }
  	validates :password_confirmation, presence: true

  	def feed
  		#basic feed
  		Post.where("user_id = ?", id)
  	end

  	private
		def create_remember_token
			# Create the token.
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
