class Status < ActiveRecord::Base
  has_many :media
  belongs_to :user

  validates :id, uniqueness: true
  validates :user_id, presence: true
  validates :text, presence: true
  validates :url, presence: true
end
