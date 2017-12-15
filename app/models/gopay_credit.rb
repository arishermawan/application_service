class GopayCredit < ApplicationRecord
  enum user_type: {
    "Customer" => 0,
    "Driver" => 1
  }

  validates :credit, :user_id, :user_type, presence:true
  validates :credit, numericality:true




end
