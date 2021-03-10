FactoryBot.define do
  factory :idea do
    body  { Faker::Lorem.sentence }

    association :category
  end
end
