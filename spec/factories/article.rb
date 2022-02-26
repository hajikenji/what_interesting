FactoryBot.define do
  factory :article do
    title { Faker::Internet.email }
    link { Faker::Internet.email }
    created_at { Faker::Time.between_dates(from: Date.today - rand(1..10), to: Date.today, period: :all)} #=> "2014-09-19 07:03:30 -0700" }
  end
end

FactoryBot.define do
  factory :article_today, class: Article do
    title { Faker::Internet.email }
    link { Faker::Internet.email }
  end
end