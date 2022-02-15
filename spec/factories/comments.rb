FactoryBot.define do
  factory :comment do
    content { "abcd" + rand(1..10).to_s }
  end
end