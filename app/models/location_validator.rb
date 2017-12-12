class LocationValidator < ActiveModel::Validator
  def validate(record)
    if !record.location.nil? && record.get_geocode.empty?
      record.errors[:location] << "is not found"
    end
  end
end
