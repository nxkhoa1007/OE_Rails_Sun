class User < ApplicationRecord
  scope :sort_by_name, -> { order(name: :asc) }

  validates :name, presence: true, length: {maximum: Settings.max_length}
  validates :email, presence: true, length: {maximum: Settings.max_length},
    uniqueness: {case_sensitive: false}, format: {with: Regexp.new(Settings.VALID_EMAIL_REGEX)}
  validates :password, presence: true, length: {minimum: Settings.min_length}, allow_nil: true
  validates :dob, presence: true

  has_secure_password
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest

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

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? attributed, token
    digest = send "#{attributed}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  private

  def downcase_email
    email.downcase!
  end
end
