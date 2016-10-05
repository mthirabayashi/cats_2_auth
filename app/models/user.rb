class User < ActiveRecord::Base

  attr_reader :password

  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  before_validation :ensure_session_token

  has_many :cats

  has_many :cat_rental_requests

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def self.reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?
    return user if user.is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end


end
