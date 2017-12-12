class Driver < ApplicationRecord

  has_secure_password
  before_save { email.downcase! }
  before_update { self.assign_location }

  enum service: {
    "goride" => 0,
    "gocar" => 1
  }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format:{ with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :phone, presence: true, numericality:true, length: { maximum: 15, minimum:6 }
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 6 }, allow_blank:true
  validates :service, inclusion: services.keys
  validates :service, presence: true
  validates :location, presence: true, on: :update, if: :location_updated?

  validates_with LocationValidator


  def api_key
    api = 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE'
  end

  def get_geocode
    result = ''
    gmaps = GoogleMapsService::Client.new(key: api_key)
    if !location.empty?
      result = gmaps.geocode(location)
      if !result.empty?
        result = result[0][:geometry][:location]
        result[:addres] = location
      end
    end
    result
  end

  def assign_location
    self.location = self.get_geocode if !location.nil?
  end

  def location_updated?
    changed.include?("location")
  end
end
