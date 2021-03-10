FactoryBot.define do
  factory :category_idea do
    name  { Faker::Lorem.words }
    body  { Faker::Lorem.sentence }
  end
end
