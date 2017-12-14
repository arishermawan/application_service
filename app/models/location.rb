class Location < ApplicationRecord

  belongs_to :area

  def self.get_location(address)
    result = ''
    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE')
    if !address.empty?
      result = gmaps.geocode(address)
      if !result.empty?
        area = result[0][:address_components]
        city =''
        area.each do |x|
          if x[:types][0]=="administrative_area_level_2"
            city = x[:short_name]
          end
        end

        geo = result[0][:geometry][:location]
        coordinate = [geo[:lat], geo[:lng]]

        pick_area = Area.find_by(name: city)

        if pick_area == nil
          pick_area = Area.create(name: city)
        end

        find_location = Location.find_by(address: address)

        if find_location == nil
          find_location = pick_area.location.create(address: address, coordinate: coordinate)
        end

        result = find_location
      end
    end
    result
  end

  def self.get_area(address)
    result = ''
    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE')
    if !address.empty?
      result = gmaps.geocode(address)
      if !result.empty?
        area = result[0][:address_components]
        result = area
      end
    end
    result
  end

  def self.testod(address)
    result=''
    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE')
    if !address.empty?
      result = gmaps.geocode(address)
      if !result.empty?
        area = result[0][:address_components]
        area.each do |x|
          if x[:types][0]=="administrative_area_level_2"
            result = x[:short_name]
          end
        end
      end
    end

    result
  end




end
