class AddEmailToTsm < ActiveRecord::Migration[5.0]
  def change
  	add_column :tsms, :email, :string 
  end
end
