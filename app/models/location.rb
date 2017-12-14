class Location < ApplicationRecord

  belongs_to :area

  def self.get_location(address)
    result = ''
    api_key = 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE'
    if !address.nil? && !address.empty?
      gmaps = GoogleMapsService::Client.new(key: api_key)
      address.downcase!
      result = gmaps.geocode(address)
      if !result.empty?
        area = result[0][:address_components]

        city = ''
        area.each do |type|
          if type[:types][0]=="administrative_area_level_2"
            city = type[:short_name].downcase
          end
        end

        check_area = save_area_not_exist(city)

        geo = result[0][:geometry][:location]
        coordinate = [geo[:lat], geo[:lng]]

        check_location = save_location_not_exist(check_area, address, coordinate)
        result = check_location
      end
    end
    result
  end

  def self.save_area_not_exist(area)
    check_area = Area.find_by(name: area)
    if check_area == nil
      check_area = Area.create(name: area)
    end
    check_area
  end

  def self.save_location_not_exist(area, address, coordinate)
    check_location = Location.find_by(address: address)
    if check_location == nil
      check_location = area.location.create(address: address, coordinate: coordinate)
    end
    check_location
  end

end
