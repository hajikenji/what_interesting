require 'rails_helper'

RSpec.describe 'userテスト', type: :system do
  describe 'user' do
    before do
      visit articles_path
       create(:article_statistic_today, article: create(:article_today))
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
        expect(page).to have_content "アカウント登録が完了しました"
      end
      it 'ログイン' do
        click_link 'ログイン'
        @user = create(:user)
        # @user.confirm
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        click_on 'commit'
        expect(page).to have_link 'マイページ'
      end
      it 'ログアウト' do
        click_link 'ログイン'
        @user = create(:user)
        # @user.confirm
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
        # @user.confirm
        sleep(0.2)
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        click_on 'commit'
      end
      it 'コメントできる' do
        click_link 'コメント一覧'
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
    context '他人のコメントを編集できないように' do
      before do
        click_link 'ログイン'
        @user = create(:user)
        # @user.confirm
        sleep(0.2)
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        click_on 'commit'
      end
      it '他人のをedit,destroyできない' do
          click_link 'コメント一覧'
          @user = create(:user)
          @article = Article.first
          @comment = @article.comments.build({ content: 'aaaaa' })
          @comment[:user_id] = @user.id
          @comment.save
          visit current_path
          expect(page).not_to have_link nil, href: article_comment_path(@article, @comment)
        end
      it '自分のはedit,destroyできる' do
          click_link 'コメント一覧'
          fill_in 'comment[content]', with: 'aaaaa'
          click_on 'commit'
          visit current_path
          @article = Article.first.id
          expect(page).to have_button '更新する'
          expect(page).to have_link '×'
          fill_in 'comment[content]', with: 'aaaaa1'
          click_on 'commit'
          expect(page).to have_content 'aaaaa1'
          click_link nil, href: article_comment_path(@article, @user.comments[0][:id])
          page.accept_confirm
          expect(page).not_to have_content 'aaaaa1'
      end
      end
    context '管理者系' do
      before do
        click_link 'ログイン'
        @user = create(:user)
        # @user.confirm
        sleep(0.2)
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        click_on 'commit'
      end
      it '管理者は画面に入れる' do
        @user.update(admin: true)
        click_link 'マイページ'
        click_link nil, href: rails_admin_path
        expect(page).to have_content 'サイト管理'
      end
      # it '管理者以外はリンクが表示されない、また入れない' do
      #     click_link 'マイページ'
      #     expect(page).not_to have_link nil, href: rails_admin_path
      #     e = visit rails_admin_path
      #     expect(e).to eq nil
      #   end
      
     end
  end

end