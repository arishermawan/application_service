class AddPasswordDigestToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :password_digest, :string
  end
end
