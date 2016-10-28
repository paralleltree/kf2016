class Status < ActiveRecord::Base
  has_many :media
  belongs_to :user

  validates :id, uniqueness: true
  validates :user_id, presence: true
  validates :text, presence: true
  validates :url, presence: true

  scope :valid_statuses, -> (blacklist_ids, filtered_words) {
    includes(:user)
      .where.not(users: { id: blacklist_ids })
      .where.not("text ~ ?", "(#{filtered_words.join("|")})")
      .select("*")
  }
end
