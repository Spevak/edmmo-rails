FactoryGirl.define do

  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :logged_in_user, class: User do
    email { generate(:email) }
    logged_in true
    # Necessary to meet Devise validation
    before(:create) { |u| u.password = 'password' ; u.save! }
  end

  factory :logged_out_user, class: User do
    email { generate(:email) }
    logged_in false
    before(:create) { |u| u.password = 'password' ; u.save! }
  end
end
