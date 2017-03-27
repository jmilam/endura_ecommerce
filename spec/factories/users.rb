FactoryGirl.define do
  factory :user do
  	id				1
    email			"test@testbot.com"
    name			"Test Bot"
    password	"test1234"
    admin			true
  end
end
