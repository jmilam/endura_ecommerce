require 'rails_helper'

RSpec.describe ReportController, type: :controller do
	before(:all) do
		@user = FactoryGirl.create(:user)
		tsm = FactoryGirl.build(:tsm)
		sales_rep = FactoryGirl.create(:sales_rep, tsm: tsm)
		@customer = FactoryGirl.create(:customer, sales_rep: sales_rep)
		@funds_bank = FactoryGirl.create(:funds_bank, customer: @customer)
		@order = FactoryGirl.create(:order, user: @user)
		@order.update(customer_id: @customer.id)
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

	describe "custom reports" do
  	describe "Run Funds Bank report" do
  		it "should generate report used funds vs. remaining funds for each customer" do
  			post :create, params: {report: {start_date: Date.today - 30.days, end_date: Date.today}, commit: "funds details by customer"}
  			funds_summary = assigns(:funds_summary)
  			expect(funds_summary["#{@customer.id}"]).to_not eq nil
  			expect((@funds_bank.current_bal - funds_summary["#{@customer.id}"][:order_sum].sum).to_i).to eq 2990
  		end
  	end
  end
end
