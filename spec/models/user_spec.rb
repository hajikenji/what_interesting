require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションテスト' do
    before do
      @user = FactoryBot.build(:user)
    end
    context 'ユーザー新規登録' do
      it '名前が空' do
        @user[:name] = ""
        expect(@user).not_to be_valid
      end
      it 'ユーザーのnameが重複する' do
        @user2 = FactoryBot.build(:user)
        @user.save
        @user2[:name] = @user.name
        expect(@user2).not_to be_valid
      end
      it '名前が16文字以上' do
        @user[:name] = '123456789aiueowq'
        expect(@user).not_to be_valid
      end
      it 'メールが不正' do
        @user[:email] = '123456789aiueowq'
        expect(@user).not_to be_valid
      end
      it '通る' do
        @user = FactoryBot.build(:user)
        @user.save
        expect(@user).to be_valid
      end
    end
  end
end