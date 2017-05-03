class RefundController < ApplicationController
  def index
  end

  def new
  	@type = "refund"
		#@table_headers = ["Name", "Actions"]
		@data_variable = FundsBank.new
		@path = refund_create_path
		@select_box_data = Customer.all.sort
		@select_id = "customer_id"
		@column_names = ["customer_id", "amount", "note"] #@data_variable.attributes.keys.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}
		respond_to do |format|
			format.js { render :template => "/partials/new" }
		end
  end

  def create
  	Order.transaction do 
  		begin
  			customer = Customer.find(params[:refund][:customer_id])
  			funds_bank = customer.funds_bank
  			new_bal = funds_bank.current_bal += params[:refund][:amount].to_f
  			funds_bank.update(current_bal: new_bal)

		  	order = current_user.orders.new(accepted: true, order_complete: true, deadline: Date.today.strftime('%Y-%m-%d'), payment_method: "Refund", customer_id: customer.id, order_reason: params[:refund][:note], address: customer.address, city: customer.city, state: customer.state, zipcode: customer.zipcode)
		  	order.save
		  	order_item = order.order_items.create(item_type: "refund", quantity: 1, reference_id: 0, item_total: params[:refund][:amount], note: params[:refund][:note])
		  	flash[:notice] = "Refund was successfully applied to #{customer.company_name}"
		  	redirect_to user_portal_index_path
		  rescue Exception => e
		  	flash[:error] = e
		  	redirect_to user_portal_index_path
		  end
		end
  end
end
