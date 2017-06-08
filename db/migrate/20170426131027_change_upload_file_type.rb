class ChangeUploadFileType < ActiveRecord::Migration[5.0]
  def change
  	change_column :tradeshow_requests, :attendee_list, :string
  	change_column :tradeshow_requests, :credit_documentation, :string
  	change_column :catalog_requests, :file_1, :string
  	change_column :catalog_requests, :file_2, :string
  end
end
