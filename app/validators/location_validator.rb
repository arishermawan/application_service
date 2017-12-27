class LocationValidator < ActiveModel::Validator
  def validate(record)
    if !record.location.nil? && record.check_geocode.empty?
      record.errors[:location] << "is not found"
    end
  end
end
