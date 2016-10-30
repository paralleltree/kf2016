class Status < ActiveRecord::Base
  has_many :media
  belongs_to :user

  validates :id, uniqueness: true
  validates :user_id, presence: true
  validates :text, presence: true
  validates :url, presence: true
  validates :created_at, presence: true

  scope :valid_statuses, -> (**args) {
    includes(:user)
      .where(deleted: false)
      .where.not(id: args[:filtered_status_ids])
      .where.not(users: { id: args[:filtered_user_ids] })
      .where("users.created_at < ?", 2.days.ago)
      .where.not("text ~ ?", "(#{args[:filtered_words].join("|")})")
  }
end
