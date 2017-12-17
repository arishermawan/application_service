class RemoveAreaFromDrivers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :drivers, :area, foreign_key: true
  end
end
