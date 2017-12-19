class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :driver, optional: true

  before_save :calculate_total, :distance_matrix
  before_update :set_order_status
  after_save :send_to_transaction_services

  enum status: {
    "searching driver" => 0,
    "driver found" => 1,
    "complete" => 2,
    "cancel" => 3
  }

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

  def get_location(origin, destination)
    uri = URI('http://localhost:3002/locations/distance')
    req = Net::HTTP::Post.new(uri)
    req.set_form_data('origin' => origin, 'destination' => destination )

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    res.body = eval(res.body)
  end

  def get_google_api
    matrix = []
    origins = pickup
    destinations = destination
    if !origins.empty? && !destinations.empty?
      matrix = get_location(origins, destinations)
    end
    matrix
  end

  def pickup_address
    result = []
    if api_not_empty?
      result = get_google_api[:origin]
      result.reject! { |address| address.empty? }
    end
    result
  end

  def destination_address
    result = []
    if api_not_empty?
      result = get_google_api[:destination]
      result.reject! { |address| address.empty? }
    end
    result
  end

  def distance_matrix
    result = 0
    if api_not_empty?
      result = get_google_api[:distance]
      result = 1.0 if result < 1.0
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
      customer.update_gopay_service
      result = true if customer.gopay >= calculate_total
    end
    result
  end

  def api_not_empty?
    !get_google_api.empty?
  end

  def set_order_status
    if self.driver_id.to_s.empty?
      self.status = 3
    else
      self.status = 1
    end
  end

  def send_to_transaction_services
    require 'kafka'
    kafka = Kafka.new( seed_brokers: ['localhost:9092'], client_id: 'transaction-service')

    order = self.attributes
    order.reject! { |key, value| value.nil? }
    order['user_order'] = id
    order.delete('id')
    order.delete('created_at')
    order.delete('updated_at')

    kafka.deliver_message("POST-->#{order.to_json}", topic: 'orderServices')
  end
end
