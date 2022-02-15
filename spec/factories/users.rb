FactoryBot.define do
  factory :user do
    name { 'dddd' + rand(1..10).to_s }
    email { Faker::Internet.email }
    password              { 'dddddd' }
    password_confirmation { 'dddddd' }
    admin                 { false }
  end
end
