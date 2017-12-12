class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :pickup
      t.string :destination
      t.integer :payment
      t.decimal :distance
      t.decimal :total
      t.belongs_to :customer, foreign_key: true
      t.belongs_to :driver, foreign_key: true

      t.timestamps
    end
  end
end
