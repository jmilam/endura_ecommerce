class OrderAcceptDenyComment < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :accept_deny_comment, :text
  end
end
