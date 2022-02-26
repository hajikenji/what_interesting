require 'rails_helper'

RSpec.describe '記事テスト', type: :system do
  describe 'article' do
    before do
       create(:article_statistic_today, article: create(:article_today))
      visit articles_path
    end
    context 'サイト訪問' do
      it '記事が見れる' do
        expect(page).to have_content Article.first.title
      end
      it '記事の各項目が漏れなく記載されている' do
        expect(page).to have_content Article.first.title
        expect(page).to have_content Article.first.article_statistic.fav
      end
      it 'スクレイピング、ちゃんと取得できているか' do
        click_link nil, href: '/my/users/admin'
        sleep(0.2)
        visit articles_path
        click_link nil, href: "/my/users/#{User.first.id}"
        click_link 'New Article'
        while true
          begin
            click_on '1ページ目'
          rescue StandardError => e
            p e
            p 'ただのタイムアウトなので続行する'
            break
          end
        end
        sleep(80)
        visit articles_path
        page.all('ul').size
        expect(page.all('ul').size / 2).to eq Article.count
      end
    end
  end
end
