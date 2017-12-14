class AddAreaIdToLocation < ActiveRecord::Migration[5.1]
  def change
    add_reference :locations, :area, foreign_key: true
  end
end
