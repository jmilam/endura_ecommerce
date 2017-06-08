class FixTyposCatalogRequest < ActiveRecord::Migration[5.0]
  def change
  	rename_column :catalog_requests, :sate, :state
  	rename_column :catalog_requests, :trilennium_multi_point, :trillenium_multi_point

  end
end
