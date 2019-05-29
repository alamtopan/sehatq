FactoryGirl.define do
  factory :user do
    full_name { Faker::Name.name }
    sequence(:username) { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@mail.com" }
    password { rand.to_s[2..10] }
  end
end