class User < ApplicationRecord
  scope :sort_by_name, -> { order(name: :asc) }

  validates :name, presence: true, length: {maximum: Settings.max_length}
  validates :email, presence: true, length: {maximum: Settings.max_length},
    uniqueness: {case_sensitive: false}, format: {with: Regexp.new(Settings.VALID_EMAIL_REGEX)}
  validates :password, presence: true, length: {minimum: Settings.min_length}, allow_nil: true
  validates :dob, presence: true

  has_secure_password
  before_save :downcase_email
  attr_accessor :remember_token

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
                BCrypt::Engine::min_cost
              else
                BCrypt::Engine.cost
              end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private

  def downcase_email
    email.downcase!
  end
end
