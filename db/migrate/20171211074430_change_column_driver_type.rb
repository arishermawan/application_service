class ChangeColumnDriverType < ActiveRecord::Migration[5.1]
  def change
    rename_column :drivers, :type, :service
  end
end
