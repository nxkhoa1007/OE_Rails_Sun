class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: Settings.max_length}
  validates :email, presence: true, length: {maximum: Settings.max_length},
    uniqueness: {case_sensitive: false}, format: {with: Regexp.new(Settings.VALID_EMAIL_REGEX)}

  has_secure_password

  before_save :downcase_email

  private
  def downcase_email
    email.downcase!
  end
end
