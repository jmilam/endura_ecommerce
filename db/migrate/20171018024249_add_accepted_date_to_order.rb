class AddAcceptedDateToOrder < ActiveRecord::Migration[5.0]
  def change
  	add_column :orders, :accepted_date, :date
  end
end
