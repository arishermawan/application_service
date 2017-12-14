class Driver < ApplicationRecord

  belongs_to :area, optional:true

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
    local_location = Location.find_by(address: location)
    location_hash = {}
    if !local_location.nil?
      @driver.update_attributes(area_id: local_location.area.id)
      location_hash[:coordinate] = local_location.coordinate
      location_hash[:address] = local_location.address
      location_hash[:city] = local_location.area.name
      result = location_hash.to_json
    else
      # gmaps = GoogleMapsService::Client.new(key: api_key)
      # if !location.empty?
      #   result = gmaps.geocode(location)
      #   if !result.empty?
      #     area = result[0][:address_components]
      #     city =''
      #     area.each do |x|
      #       if x[:types][0]=="administrative_area_level_2"
      #         city = x[:short_name]
      #       end
      #     end
      #     result = result[0][:geometry][:location]
      #     result[:address] = location
      #     result[:area] =
      #     result = result.to_json
      #   end
      # end
    end
    result
  end

  def address
    address = eval(location)
    address[:address]
  end

  def longitude
    address = eval(location)
    address[:lng]
  end

  def latitude
    address = eval(location)
    address[:lat]
  end

  def coordinate
    [latitude, longitude]
  end

  def self.distance(loc1, loc2)
    rad_per_deg = Math::PI/180
    rkm = 6371
    rm = rkm * 1000

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c
  end

  def assign_location
    self.location = self.get_geocode if !location.nil?
  end

  def location_updated?
    changed.include?("location")
  end
end
