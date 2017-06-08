class AddNotesToTradshowRequest < ActiveRecord::Migration[5.0]
  def change
  	add_column :tradeshow_requests, :note, :text
  end
end
