FactoryGirl.define do
  factory :order_item do
    order
    id					1
    item_type		"product"
    quantity		100
    reference_id	1
    item_total	10.0
  end
end
