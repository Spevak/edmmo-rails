FactoryGirl.define do

  factory :character do
    name "Mama Ghetti"
    health 100
    battery 100
    planet "Earth"
  end

  factory :item do
    pickupable true
    walkoverable true
  end

end
