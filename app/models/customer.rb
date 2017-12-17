class Customer < ApplicationRecord

  has_secure_password
  has_many :orders

  before_save { email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format:{ with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :phone, presence: true, numericality:true, length: { maximum: 15, minimum:6 }

  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 6 }, allow_blank:true
  validates :gopay, presence: true, numericality: { greater_than_or_equal_to: 0.01 }, on: :update, if: :gopay_changed?

  def gopay_changed?
    changed.include?("gopay")
  end

  def topup_gopay(amount)
    gopay_balance = GopayCredit.add_credit(amount, id, self.class.to_s)
  end

end
