require 'rails_helper'

RSpec.describe 'Admin Functions', type: :feature do
	let!(:user) { FactoryGirl.create(:user) }

	before :each do
		sign_in user
	end

	context 'A user logs in as an Admin' do
		it 'should show all Admin Functions' do
		end
	end
end