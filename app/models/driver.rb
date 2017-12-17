class Driver < ApplicationRecord

  belongs_to :area, optional:true
  has_many :orders

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

  def get_geocode
    result = ''
    find_location = set_location(location, id, location_id)
    if !find_location.nil?
      result = find_location
      puts "---------------------------------------------#{result}"
    end
    if !result.empty?
      self.location_id = result[:id]
      hash = {}
      hash[:coordinate] = result[:coordinate]
      hash[:address] = result[:address]
      result = hash
    end
    result
  end

  def set_location(address, driver, location_id)
    uri = URI('http://localhost:3001/locations/driver')
    req = Net::HTTP::Post.new(uri)
    req.set_form_data('address' => address, 'driver_id' => id, 'location_id' => location_id )

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    res.body = eval(res.body)
  end

  def address
    address = eval(location)
    address[:address]
  end

  def coordinate
    address = eval(location)
    coord = eval(address[:coordinate])
  end

  def assign_location
    self.location = self.get_geocode.to_json if !location.nil?
  end

  def location_updated?
    changed.include?("location")
  end
end
