class RemoveServiceTypeFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :service_type, :integer
  end
end
