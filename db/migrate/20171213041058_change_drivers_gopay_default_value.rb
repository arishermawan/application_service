class ChangeDriversGopayDefaultValue < ActiveRecord::Migration[5.1]
  def change
    change_column_default :drivers, :gopay, 0
  end
end
