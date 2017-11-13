class CreateSubFinishes < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_finishes do |t|
    	t.integer :product_finish_id
    	t.string	:name
      t.timestamps
    end
    add_index :sub_finishes, :product_finish_id
  end
end
