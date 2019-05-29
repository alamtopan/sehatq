class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates_presence_of :title, :price

  has_many :order_items

  mount_uploader :cover_image, ImageUploader

  include ProductModule::Filter
end
