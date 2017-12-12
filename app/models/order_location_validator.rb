class OrderLocationValidator < ActiveModel::Validator
  def validate(record)
    if !record.pickup.empty? && !record.get_google_api.empty?
      if record.pickup_address.empty?
        record.errors[:pickup] << "is not found"
      end
    end

    if !record.destination.empty? && !record.get_google_api.empty?
      if record.destination_address.empty?
        record.errors[:destination] << "is not found"
      end
    end

  end
end
