FactoryGirl.define do

  sequence :email do |n|
    "user#{n}@example.com"
  end
  
  factory :user do
    email { generate(:email) }
    logged_in false
    before(:create) { |u| u.password = 'password' ; u.save! }
  end
end
