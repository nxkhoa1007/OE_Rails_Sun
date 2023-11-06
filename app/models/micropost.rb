class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [
      Settings.digit_500,
      Settings.digit_500
    ]
  end

  validates :content, presence: true, length: {maximum: Settings.digit_140}

  scope :newest, ->{order(created_at: :desc)}
  scope :relate_post, ->(user_ids){where user_id: user_ids}
end
