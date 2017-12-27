class OrderLocationValidator < ActiveModel::Validator
  def validate(record)
    request = record.get_google_api
    if !record.pickup.empty? && !request.empty?
      if record.pickup_address.empty?
        record.errors[:pickup] << "is not found"
      end
    end

    if !record.destination.empty? && !request.empty?
      if record.destination_address.empty?
        record.errors[:destination] << "is not found"
      end
    end

    if record.distance_matrix > 25.0
      record.errors[:destination] << "distance is greater than 25 km, we only serve maximum 25 km"
    end
  end
end
