FactoryBot.define do
  factory :user do
    name { 'dddd' + rand(1..10).to_s }
    email { 'asd@asd.com' }
    password              { 'dddddd' }
    password_confirmation { 'dddddd' }
    admin                 { false }
    # after(:create) { |user| user.confirm }
  end
end
