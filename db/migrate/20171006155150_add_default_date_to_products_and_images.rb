class AddDefaultDateToProductsAndImages < ActiveRecord::Migration[5.0]
  def change
  	change_column :images, :created_at, :datetime, default: Date.today 
  	change_column :images, :updated_at, :datetime, default: Date.today 
  	change_column :products, :created_at, :datetime, default: Date.today 
  	change_column :products, :updated_at, :datetime, default: Date.today 
  end
end
