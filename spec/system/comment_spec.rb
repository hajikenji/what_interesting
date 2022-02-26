require 'rails_helper'

# fill_inでログイン作業
# 登録作業での失敗例は不要とする。modelでsaveまでいけてるので
# ログイン後に記事、コメント、マイページが見れる
# ログイン後コメントできる、多重投稿はこれも不要。またマイページでupdate,destroy
# ログアウトできる
# 非ログイン時に記事、コメントが見れる。コメントはできない。
# 記事がちゃんとvalue順に並ぶ、各項目がちゃんとあるか
# コメント欄にはちゃんと画像と名前とコメント内容がある

RSpec.describe 'サイト全体テスト', type: :system do
  describe '閲覧機能' do
    before do
      create(:article_statistic_today, article: create(:article_today))
      create(:user)
      visit articles_path
    end
    context 'サイト訪問' do
      it '記事が見れる' do

        expect(page).to have_content Article.first.title
      end
      it 'コメントが見れる' do
        click_link 'コメント一覧'
        @user = create(:user)
        @article = Article.first
        @comment = @article.comments.build({ content: 'aaaaa' })
        @comment[:user_id] = @user.id
        @comment.save
        visit current_path
        expect(page).to have_selector '.default'
        expect(page).to have_content @comment.content
      end
      it '非ログイン時コメント投稿はできない、画面上操作' do
        click_link 'コメント一覧'
        expect(page).to have_content "※コメント投稿にはログインが必要です"
      end
      it '非ログイン時コメント投稿はできない、単純にcreateを弾けるか' do
        begin
          create(:comment)
        rescue => e
          e = e.class
        end
        expect(e).to be ActiveRecord::RecordInvalid
      end
      it '記事の各項目が漏れなく記載されている' do
        expect(page).to have_content Article.first.title
        expect(page).to have_content Article.first.article_statistic.fav
        expect(page).to have_content Article.first.article_statistic.comment
      end
    end
  end
end