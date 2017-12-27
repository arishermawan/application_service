class ChangeColumnDriversGopay < ActiveRecord::Migration[5.1]
  def change
    rename_column :customers, :gopay_credit_id, :gopay_id
    rename_column :drivers, :gopay_credit_id, :gopay_id
  end
end
