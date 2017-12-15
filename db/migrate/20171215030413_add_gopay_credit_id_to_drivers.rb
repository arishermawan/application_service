class AddGopayCreditIdToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :gopay_credit_id, :integer
  end
end
