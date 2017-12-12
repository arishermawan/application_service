class ChangeUsersGopayDefaultValue < ActiveRecord::Migration[5.1]
  def change
    change_column_default :customers, :gopay, 0
  end
end
