# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + "/environment")
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :production
# cronを実行する環境変数をセット
set :environment, rails_env
# 出力先のログファイルの指定
set :output, "#{Rails.root}/log/cron.log"
# ジョブの実行環境の指定
set :environment, :development

# yahoo
# url = "https://news.yahoo.co.jp/topics/top-picks?page=#{params[:name].to_i}"
def url(page_number)
  "https://news.yahoo.co.jp/topics/top-picks?page=#{page_number}"
end

# 3時間毎に実行するスケジューリング
every 10.minutes do
  runner "ArticleStatistic.whenever_test"
end
every 15.minutes do
  runner "ArticleStatistic.whenever_test"
end

every 1.hours do
  runner "ArticleStatistic.scraping_yahoo(#{url(1)})"
end
every 2.hours do
  runner "ArticleStatistic.scraping_yahoo(#{url(2)})"
end
every 3.hours do
  runner "ArticleStatistic.scraping_yahoo(#{url(3)})"
end
every 4.hours do
  runner "ArticleStatistic.scraping_yahoo(#{url(4)})"
end