class AddGopayCreditIdToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :gopay_credit_id, :integer
  end
end
