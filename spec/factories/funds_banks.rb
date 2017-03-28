FactoryGirl.define do
  factory :funds_bank do
    customer
    allocated_amt 3000.00
    current_bal   3000.00
  end
end
