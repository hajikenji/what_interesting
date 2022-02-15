require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーションテスト' do
    before do
      @user = create(:user)
      @article = create(:article)
 
      @comment = @article.comments.build({ content: 'aaaaa' })
      @comment[:user_id] = @user.id
    end
    context 'コメント投稿' do
      it 'コメントが空' do
        @comment[:content] = ""
        expect(@comment).not_to be_valid
      end
      it 'コメントが16文字以上' do
        @comment[:content] = '123456789aiueowq'
        expect(@comment).not_to be_valid
      end
      it 'unique ユーザーが1記事に多重投稿' do
        @comment.save
        @comment2 = @article.comments.build({ content: 'aaaaa' })
        @comment2[:user_id] = @user.id
        expect(@comment2).not_to be_valid
      end
      it '通る' do
        expect(@comment).to be_valid
      end
    end
  end
end
