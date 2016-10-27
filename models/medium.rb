class Medium < ActiveRecord::Base
  belongs_to :status

  validates :id, uniqueness: true
  validates :status_id, presence: true
  validates :url, presence: true
end
