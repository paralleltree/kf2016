class User < ActiveRecord::Base
  has_many :status

  validates :id, uniqueness: true
  validates :screen_name, presence: true
  validates :name, presence: true
  validates :profile_image_url, presence: true
end
