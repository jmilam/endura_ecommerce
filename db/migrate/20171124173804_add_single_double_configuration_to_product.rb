class AddSingleDoubleConfigurationToProduct < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :configurable_sides_count, :integer, default: 1
  end
end
