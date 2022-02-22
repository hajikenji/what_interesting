require 'rails_helper'

def check_expect(num, d)
    a = page.all('.article_info')[num].text
    b = a.slice(a.size - 5..a.size).gsub(':','').to_i
    expect(b).to eq d[num][:ranking]
    expect(b).not_to eq d[num - 1][:ranking]
end

def check_expect_fav(num, d)
  a = page.all('.article_info')[num].text
  b = a.slice(7..12).gsub(':','').to_i
  expect(b).to eq d[num].article_statistic.fav
  expect(b).not_to eq d[num - 1].article_statistic.fav
end

def check_expect_comment(num, d)
  a = page.all('.article_info')[num].text
  b = a.slice(21..25).gsub(':','').to_i

  expect(b).to eq d[num].article_statistic.comment
  expect(b).not_to eq d[num - 1].article_statistic.comment
end

def check_sort_totalling(active_record)
  # c = Article.all.eager_load(:article_statistic)
  sleep(0.2)
  c = active_record
  c.each do |article|
    num = article.article_statistic.fav + article.article_statistic.comment
    article[:ranking] = num
  end
  d = c.sort_by { |x| x[:ranking] }.reverse


  check_expect(0, d)
  check_expect(1, d)
  num = page.all('.article_info').size
  check_expect(num - 1, d)
end

def check_sort_fav(active_record)
  # c = Article.all.eager_load(:article_statistic)
  sleep(0.2)
  c = active_record
  d = c.order(fav: "DESC")


  check_expect_fav(0, d)
  check_expect_fav(1, d)
  num = page.all('.article_info').size
  check_expect_fav(num - 1, d)
end

def check_sort_comment(active_record)
  # c = Article.all.eager_load(:article_statistic)
  sleep(0.2)
  c = active_record
  d = c.order(comment: "DESC")


  check_expect_comment(0, d)
  check_expect_comment(1, d)
  num = page.all('.article_info').size
  check_expect_comment(num - 1, d)
end


RSpec.describe '記事テスト', type: :system do
  describe 'article' do
    before do
      50.times do 
        create(:article_statistic)
      end
      visit articles_path
      sleep(0.4)
    end
    context '並び順総合の全期間テスト' do
      it '総合ランキング、総合' do
        # binding.irb
        select '総合ランキング', from: 'time'
        select '総合', from: 'sort_algorithm'
        click_on 'commit'
        sleep(0.4)
        
        active_record = Article.all.eager_load(:article_statistic)

        check_sort_totalling(active_record)
      end
      it '1週間ランキング、総合' do
        select '1週間のランキング', from: 'time'
        select '総合', from: 'sort_algorithm'
        click_on 'commit'
        sleep(0.4)
        # binding.irb

        active_record = Article.where(created_at: Time.now.ago(7.days)..Time.now)
        active_record = active_record.all.eager_load(:article_statistic)

        check_sort_totalling(active_record)

        # c = Article.all.eager_load(:article_statistic)
        # c.each do |article|
        #   num = article.article_statistic.fav + article.article_statistic.comment
        #   article[:ranking] = num
        # end
        # @d = c.sort_by { |x| x[:ranking] }.reverse

        # def check(num)
        #   a = page.all('.article_info')[num].text
        #   b = a.slice(a.size - 5..a.size).gsub(':','').to_i
        #   expect(b).to eq @d[num][:ranking]
        # end

        # check(0)
        # check(1)
        # num = page.all('.article_info').size
        # check(num - 1)
      end
      it '24時間ランキング、総合' do
        select '24時間ランキング', from: 'time'
        select '総合', from: 'sort_algorithm'
        click_on 'commit'
        sleep(0.4)
        active_record = Article.where(created_at: Time.now.yesterday..Time.now)
        active_record = active_record.all.eager_load(:article_statistic)

        check_sort_totalling(active_record)
      end

      context '並び順いいねの全期間テスト' do
      it '総合ランキング、いいね' do
        # binding.irb
        select '総合ランキング', from: 'time'
        select 'いいね', from: 'sort_algorithm'
        click_on 'commit'
        sleep(0.4)
        
        active_record = Article.all.eager_load(:article_statistic)

        check_sort_fav(active_record)
      end
      it '1週間ランキング、総合' do
        select '1週間のランキング', from: 'time'
        select 'いいね', from: 'sort_algorithm'
        click_on 'commit'
        sleep(0.4)
        # binding.irb

        active_record = Article.where(created_at: Time.now.ago(7.days)..Time.now)
        active_record = active_record.all.eager_load(:article_statistic)

        check_sort_fav(active_record)

      end
      it '24時間ランキング、総合' do
        select '24時間ランキング', from: 'time'
        select 'いいね', from: 'sort_algorithm'
        click_on 'commit'
        sleep(0.4)
        active_record = Article.where(created_at: Time.now.yesterday..Time.now)
        active_record = active_record.all.eager_load(:article_statistic)

        check_sort_fav(active_record)
      end
    end
    context '並び順コメントの全期間テスト' do
      it '総合ランキング、コメント' do
        # binding.irb
        select '総合ランキング', from: 'time'
        select 'コメント', from: 'sort_algorithm'
        click_on 'commit'
        sleep(0.4)
        
        active_record = Article.all.eager_load(:article_statistic)

        check_sort_comment(active_record)
      end
      it '1週間ランキング、コメント' do
        select '1週間のランキング', from: 'time'
        select 'コメント', from: 'sort_algorithm'
        click_on 'commit'
        sleep(0.4)
        # binding.irb

        active_record = Article.where(created_at: Time.now.ago(7.days)..Time.now)
        active_record = active_record.all.eager_load(:article_statistic)

        check_sort_comment(active_record)

      end
      it '24時間ランキング、コメント' do
        select '24時間ランキング', from: 'time'
        select 'コメント', from: 'sort_algorithm'
        click_on 'commit'
        sleep(0.4)
        active_record = Article.where(created_at: Time.now.yesterday..Time.now)
        active_record = active_record.all.eager_load(:article_statistic)

        check_sort_comment(active_record)
      end
    end
    end
  end
end
