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

# 3時間毎に実行するスケジューリング
every 10.minutes do
  runner "ArticleStatistic.whenever_test"
end