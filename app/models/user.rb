class User < ApplicationRecord
	extend FriendlyId
	friendly_id :username, use: :slugged
	
	attr_accessor :password

	has_many :tokens, dependent: :destroy
	has_many :orders, dependent: :destroy
	has_many :order_items, through: :orders

	validates_presence_of :username, :full_name
	validates_uniqueness_of :username
	validates_uniqueness_of :email, allow_blank: true
	validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/i

	before_save :encrypt_password

	include BCrypt
	include UserModule::Auth

	mount_uploader :avatar, ImageUploader
  
	def activated?
		self.activated == true
	end

	def inactivated?
		self.activated == false
  end

end
