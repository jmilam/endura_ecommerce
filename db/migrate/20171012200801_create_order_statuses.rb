class CreateOrderStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :order_statuses do |t|
    	t.text :status

      t.timestamps
    end

    OrderStatus.create(status: "Pending")
    OrderStatus.create(status: "Approved")
    OrderStatus.create(status: "Denied")
    OrderStatus.create(status: "In Progress")
    OrderStatus.create(status: "Shipped")
    OrderStatus.create(status: "Complete")
  end
end
