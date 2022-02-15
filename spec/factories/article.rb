FactoryBot.define do
  factory :article do
    title { Faker::Internet.email }
    link { Faker::Internet.email }
  end
end
