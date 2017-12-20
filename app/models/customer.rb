class Customer < ApplicationRecord

  has_secure_password
  has_many :orders

  before_save { email.downcase! if email_changed? }

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
    result = ""
    if gopay_id.nil?
      result = create_gopay_service(amount)
    else
      result = add_gopay_service(amount)
    end
    result
  end

  def create_gopay_service(credit)
    uri = URI('http://localhost:3001/gopays')
    req = Net::HTTP::Post.new(uri)
    req.set_form_data('credit' => credit, 'user_id' => id, 'user_type' => self.class.to_s )
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    res.body = eval(res.body)
  end

  def add_gopay_service(credit)
    uri = URI("http://localhost:3001/gopays/#{gopay_id}/add")
    req = Net::HTTP::Patch.new(uri)
    req.set_form_data('credit' => credit )
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    res.body = eval(res.body)
  end

  def update_gopay_service
    uri = URI("http://localhost:3001/gopays/#{gopay_id}")
    req = Net::HTTP::Get.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    result = eval(res.body)
    gopay_update = result[:credit].to_f

    self.update(gopay: gopay_update) if gopay != gopay_update
  end

  def email_changed?
    changed.include?("email")
  end
end
