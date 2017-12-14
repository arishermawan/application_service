class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :driver, optional: true

  before_save :calculate_total, :distance_matrix

  enum service: {
    "goride" => 0,
    "gocar" => 1
  }

  enum payment: {
    "cash" => 0,
    "gopay" => 1
  }

  validates_with OrderLocationValidator
  validates_with GopayValidator
  validates :payment, inclusion: payments.keys
  validates :service, inclusion: services.keys
  validates :pickup, :destination, :payment, presence:true

  def api_key
    api = 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE'
  end

  def get_google_api
    matrix = []
    gmaps = GoogleMapsService::Client.new(key: api_key)
    origins = pickup
    destinations = destination
    if !origins.empty? && !destinations.empty?
      matrix = gmaps.distance_matrix(origins, destinations, mode: 'driving', language: 'en-AU', avoid: 'tolls')
    end
    matrix
  end

  def pickup_address
    result = []
    if api_not_empty?
      result = get_google_api[:origin_addresses]
      result.reject! { |address| address.empty? }
    end
    result
  end

  def destination_address
    result = []
    if api_not_empty?
      result = get_google_api[:destination_addresses]
      result.reject! { |address| address.empty? }
    end
    result
  end

  def distance_matrix
    result = 0
    if api_not_empty?
      if get_google_api[:rows][0][:elements][0][:status] == "OK"
        result = get_google_api[:rows][0][:elements][0][:distance][:value]
        result = (result.to_f / 1000).round(2)
        result = 1.0 if result < 1.0
      end
    end
    self.distance = result
  end

  def cost_per_km
    service == 'gocar' ? 2500 : 1500
  end

  def calculate_total
    total = 0
    if api_not_empty?
      total = distance_matrix * cost_per_km
    end
    self.total = total
  end

  def gopay_sufficient?
    result = false
    if api_not_empty?
      result = true if customer.gopay >= calculate_total
    end
    result
  end

  def api_not_empty?
    !get_google_api.empty?
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

  def get_geocode
    result = ''
    gmaps = GoogleMapsService::Client.new(key: api_key)
    if !pickup.empty?
      result = gmaps.geocode(pickup)
      if !result.empty?
        area = result[0][:address_components][4][:short_name]
        geo = result[0][:geometry][:location]
        coordinate = [geo[:lat], geo[:lng]]
        result = [coordinate, area]
      end
    end
    result
  end

end
