class AddAreaToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_reference :drivers, :area, foreign_key: true
  end
end
