class GopayValidator < ActiveModel::Validator
  def validate(record)

    if record.payment_type == "gopay"
      gopay = User.find(record.customer_id).gopay
      if gopay < record.total
        record.errors[:payment] << "gopay credit isn't enough"
      end
    end
  end
end
