# config valid only for current version of Capistrano
lock '3.16.0'

# アプリケーション名
set :application, 'what_interesting'

# cloneするgitのレポジトリ
set :repo_url, 'https://github.com/hajikenji/what_interesting'

# deployするブランチ。mainを使用している場合、masterをmainに変更
set :branch, ENV['BRANCH'] || 'master'

# deploy先のディレクトリ
set :deploy_to, '/var/www/what_interesting'

# シンボリックリンクを貼るるフォルダ・ファイル
set :linked_files, %w[.env config/secrets.yml]
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets public/uploads]

# 保持するバージョンの個数
set :keep_releases, 5

# Rubyのバージョン
set :rbenv_ruby, '3.0.1'
set :rbenv_type, :system

# whenever
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# 出力するログのレベル。エラーログを詳細に見たい場合は :info から :debug に設定
set :log_level, :debug

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Create database'
  task :db_create do
    on roles(:db) do |_host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end

  desc 'Run seed'
  task :seed do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end
