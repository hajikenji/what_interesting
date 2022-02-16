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
      visit articles_path
    end
    context 'サイト訪問' do
      it '記事が見れる' do
        expect(page).to have_content Article.first.title
      end
      it 'コメントが見れる' do
        click_link 'コメント一覧', href: new_article_comment_path(Article.first.id)
        @user = create(:user)
        @article = Article.first
        @comment = @article.comments.build({ content: 'aaaaa' })
        @comment[:user_id] = @user.id
        @comment.save
        visit current_path
        expect(page).to have_selector '.default'
        expect(page).to have_content @comment.content
      end
      it '非ログイン時コメント投稿はできない' do
        click_link 'コメント一覧', href: new_article_comment_path(Article.first.id)
        expect(page).to have_content "※コメント投稿にはログインが必要です"
      end
      it '非ログイン時コメント投稿はできない' do
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
        expect(page).to have_content Article.first.link
      end
    context 'ログイン関連' do
      # 新規登録はmodelテストでやっているので、単純に通過するかだけをテストする
      it '新規登録' do
        click_link '新規登録'
        @user = build(:user)
        fill_in 'user[name]', with: @user.name
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        fill_in 'user[password_confirmation]', with: @user.password
        click_on 'commit'
        expect(page).to have_content "本人確認用のメールを送信しました"
      end
      it 'ログイン' do
        click_link 'ログイン'
        @user = create(:user)
        @user.confirm
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        click_on 'commit'
        expect(page).to have_link 'マイページ'
      end
      it 'ログアウト' do
        click_link 'ログイン'
        @user = create(:user)
        @user.confirm
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        click_on 'commit'
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました。'
        expect(page).to have_link 'ログイン'
      end
    end
    context 'ログイン後の各機能' do
      before do
        click_link 'ログイン'
        @user = create(:user)
        @user.confirm
        sleep(0.2)
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        click_on 'commit'
      end
      it 'コメントできる' do
        click_link 'コメント一覧', href: new_article_comment_path(Article.first.id)
        fill_in 'comment[content]', with: 'aaaaa'
        click_on 'commit'
        visit current_path
        expect(page).to have_content 'aaaaa'
      end
      it 'マイページで名前が変えられる' do
        click_link 'マイページ'
        expect(page).to have_content @user.name
        fill_in 'user[name]', with: 'fffff'
        click_on 'commit'
        expect(page).to have_content 'fffff'
      end
      it '退会できてデータが残っていない' do
        click_link 'マイページ'
        click_on '退会する'
        click_link 'ログイン'
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        click_on 'commit'
        expect(page).to have_content 'Eメールまたはパスワードが違います。'
      end
    end

    end
  end
end