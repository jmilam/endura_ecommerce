FactoryGirl.define do
  factory :customer do
    sales_rep
    company_name		"Test Co."
    contact_email		"test@test.com"
    phone_number		"336-123-4567"
    address				"1234 Test Rd."
    city				"Greensboro"
    state				"NC"
    zipcode				"27407"
    company_contact	    "Test Bot"
  end
end
