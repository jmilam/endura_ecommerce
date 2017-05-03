class AddFieldsToTradeshowRequest < ActiveRecord::Migration[5.0]
  def change
  	add_column :tradeshow_requests, :booth_assistance, :string
  	add_column :tradeshow_requests, :hotel_assistance, :string
  end
end
