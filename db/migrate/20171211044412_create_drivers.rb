class CreateDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :location
      t.integer :type
      t.decimal :gopay

      t.timestamps
    end
  end
end
