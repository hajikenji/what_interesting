FactoryBot.define do
  factory :article_statistic do
    association :article
    fav { rand(100..5000) }
    comment { rand(100..5000) }
  end
end
