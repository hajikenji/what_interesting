FactoryBot.define do
  factory :user do
    name { 'dddd' + rand(1..10).to_s }
    email { rand(1..100).to_s + "asd@asd.com" }
    password              { 'dddddd' }
    password_confirmation { 'dddddd' }
    admin                 { false }
    # after(:create) { |user| user.confirm }
  end
end
