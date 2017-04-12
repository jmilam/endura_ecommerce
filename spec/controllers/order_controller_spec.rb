require 'rails_helper'

RSpec.describe OrderController, type: :controller do
	before(:all) do
		@user = FactoryGirl.create(:user)
		tsm = FactoryGirl.build(:tsm)
		sales_rep = FactoryGirl.create(:sales_rep, tsm: tsm)
		@customer = FactoryGirl.create(:customer, sales_rep: sales_rep)
		@funds_bank = FactoryGirl.create(:funds_bank, customer: @customer)
		@order = FactoryGirl.create(:order, user: @user)
		@order.update(company_id: @customer.id)
		FactoryGirl.create(:order_item, order: @order)
	end

	after(:all) do
		User.delete_all
		Order.delete_all
		FundsBank.delete_all
		Customer.delete_all
		Tsm.delete_all
		SalesRep.delete_all
		OrderItem.delete_all
	end

	before(:each) do
		sign_in @user
	end


  describe "PUT #update" do
  	describe "Saves updates to order successfully" do
	  	it "should update Order" do
	  		put :update, params: {order: {deadline: "2050-01-01", deadline_reason: "Test for years", order_reason: "To test update methods", payment_method: "Rebate/Marketing Funds", company_id: @customer.id}, order_recipient: @customer.company_contact, email: @customer.contact_email, phone_number:@customer.phone_number, address: @customer.address, city: @customer.city, state: @customer.state, zipcode: @customer.zipcode, job: "checkout", id: @order.id}
	  		order = Order.find(@order.id)
	  		expect(flash[:notice]).to eq('Your order was placed!')
	  		expect(@customer.funds_bank.current_bal).to eq(3000.0)
	  		expect(order.order_reason).to eq('To test update methods')
	  	end

	  	# it "should update Funds Bank when approved" do
	  	# 	put :update, params: {accepted: true, job: "approve", company_id: @customer.id, id: @order.id}
	  	# 	expect(Customer.last.funds_bank.current_bal).to eq(2990.0)
	  	# end
	  end

	  describe "should not update Order due to missing fields being validated" do
	  	it "should fail, missing email" do
	  		put :update, params: {order: {deadline: "2050-01-01", deadline_reason: "Test for years", order_reason: "To test update methods", payment_method: "Rebate/Marketing Funds", company_id: @customer.id}, order_recipient: @customer.company_contact, email: "", phone_number:@customer.phone_number, address: @customer.address, city: @customer.city, state: @customer.state, zipcode: @customer.zipcode, job: "checkout", id: @order.id}
	  		order = Order.find(@order.id)
	  		expect(flash[:notice]).to eq('Your order was placed!')
	  		expect(@customer.funds_bank.current_bal).to eq(3000.0)
	  		expect(order.order_reason).to eq('To test update methods')
	  	end
	  end
  end

end
