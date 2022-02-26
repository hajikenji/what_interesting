FactoryBot.define do
  factory :article_statistic do
    association :article
    fav { rand(1000..5000) }
    comment { rand(1000..5000) }
  end
end

FactoryBot.define do
  factory :article_statistic_today, class: ArticleStatistic do
    fav { rand(1000..5000) }
    comment { rand(1000..5000) }
  end
end