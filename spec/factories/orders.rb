FactoryGirl.define do
  factory :order do
    current_order			true
    order_complete		false
    deadline					nil
    deadline_reason		nil
    payment_method		nil
    company_id				nil
    order_reason			nil
    address						nil
    city							nil
    state							nil
    zipcode						nil
  end
end
