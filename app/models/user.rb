class User < ApplicationRecord

  has_secure_password
  has_many :assignments
  has_many :roles, through: :assignments

  before_save { email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format:{ with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :phone, presence: true, numericality:true, length: { maximum: 15, minimum:6 }

  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 6 }, allow_blank:true
end
