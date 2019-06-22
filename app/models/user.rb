class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum: 20}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 100},
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  has_secure_password



  def new
    @user = User.new
  end
end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
