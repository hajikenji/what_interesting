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
# def url(page_number)
#   "https://news.yahoo.co.jp/topics/top-picks?page=#{page_number}"
# end

# スクレイピング実行の時間間隔アルゴリズム
# time(12, '00')で1時間ごと00分のタイミングで実行、(6, '10')で2時間ごと10分のタイミング...等
def time(times, minutes)
  @time_list = []
  time_whenever(times, minutes, 'am')
  time_whenever(times, minutes, 'pm')
end
def time_whenever(times, minutes, noon)
  increment = 12 / times
  num = 0
  num = 1 if times < 6
  times.times do |_a|
    @time_list << "#{num}:#{minutes} #{noon}"
    num += increment
  end
  @time_list
end

# 正常動作の確認のためログを残す
every 10.minutes do
  runner "ArticleStatistic.whenever_test"
end
every 15.minutes do
  runner "ArticleStatistic.whenever_test"
end

# スクレイピング時刻表
every 1.day, at: time(6, '05') do
  runner "ArticleStatistic.scraping_yahoo(1)"
end
every 1.day, at: time(4, '15') do
  runner "ArticleStatistic.scraping_yahoo(2)"
end
every 1.day, at: time(3, '25') do
  runner "ArticleStatistic.scraping_yahoo(3)"
end
every 1.day, at: time(3, '35') do
  runner "ArticleStatistic.scraping_yahoo(4)"
end