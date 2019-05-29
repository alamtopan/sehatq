FactoryGirl.define do
  factory :product do
    title { Faker::Name.name }
    category { Faker::Name.name }
    stock { 100 }
    description {}
    price {100000}
  end
end