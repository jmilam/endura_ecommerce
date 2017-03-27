require 'rails_helper'

RSpec.describe API, type: :model do
	before(:all) do
		@api = API.new(Rails.env)
		@user = FactoryGirl.create(:user)
		@tsm = FactoryGirl.build(:tsm)
		@rep = FactoryGirl.build(:sales_rep, tsm: @tsm)
		@order = FactoryGirl.create(:order, user: @user)
		FactoryGirl.create(:order_item, order: @order)
	end

	after(:all) do
		User.delete_all
		Tsm.delete_all
		Order.delete_all
		OrderItem.delete_all
	end

	describe "initialize" do
  	it "Should initialize variables" do	
  		expect(@api.url).to eq("http://localhost:3000/api/endura")
	  end
	end

	describe "sending email data to Endura API" do
		it "Should send data for tsm email" do 
			expect(@api.send_tsm_email(@tsm.email, @user.email, @user.name, @order.id)).to eq(true)
		end
	end

end
