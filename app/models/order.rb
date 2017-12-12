class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :driver


  enum payment: {
    "cash" => 0,
    "gopay" => 1
  }

  validates :payment, inclusion: payments.keys
  validates :pickup, :destination, :payment, presence:true


  def get_google_api
    gmaps = GoogleMapsService::Client.new(key: api_key)
    origins = pickup
    destinations = destination
    if !origins.empty? && !destinations.empty?
      matrix = gmaps.distance_matrix(origins, destinations, mode: 'driving', language: 'en-AU', avoid: 'tolls')
      matrix[:rows][0][:elements][0]
    end
  end

  def distance
    result = 0
    if api_not_nil?
      if get_google_api[:status] == "OK"
        result = get_google_api[:distance][:value]
      end
    end
    result
  end

  def api_not_nil?
    !get_google_api.nil?
  end
end
