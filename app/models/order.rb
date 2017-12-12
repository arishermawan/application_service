class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :driver, optional: true

  enum payment: {
    "cash" => 0,
    "gopay" => 1
  }

  validates_with OrderLocationValidator
  validates :payment, inclusion: payments.keys
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


  def self.google_api(pickup, destination)
    matrix = []
    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE')
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

  def distance
    result = 0
    if api_not_empty?
      if get_google_api[:rows][0][:elements][0][:status] == "OK"
        result = get_google_api[:rows][0][:elements][0][:distance][:value]
      end
    end
    result
  end

  def api_not_empty?
    !get_google_api.empty?
  end
end
