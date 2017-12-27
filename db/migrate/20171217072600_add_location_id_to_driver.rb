class AddLocationIdToDriver < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :location_id, :integer
  end
end
