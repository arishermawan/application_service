class AddServiceTypeToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :service_type, :integer
  end
end
