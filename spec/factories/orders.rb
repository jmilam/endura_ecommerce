FactoryGirl.define do
  factory :order do
    current_order			true
    order_complete		    false
    deadline				'2012-12-25'
    deadline_reason		    'Test Order'
    payment_method		    'Rebate/Marketing Funds'
    customer_id				nil
    order_reason			'To test order functions'
    address					'8817 W Market St'
    city					'Colfax'
    state					'NC'
    zipcode					27235
    email                   'jmilam@enduraproducts.com'
  end
end
