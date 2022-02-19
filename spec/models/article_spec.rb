require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'バリデーションテスト' do
    before do
      @article = create(:article)
      @article_statistics = create(:article_statistic)

      # @article_statictics = @article.article_statistic.build(fav: rand(100..5000))
      # @article_statictics.save!
    end
    context '記事' do
      it '記事が登録できる' do
        @article = build(:article)
        expect(@article).to be_valid
      end
      it 'リンクが足りない' do
        @article = build(:article)
        @article[:link] = ""
        expect(@article).not_to be_valid
      end
      it 'タイトルが足りない' do
        @article = build(:article)
        @article[:title] = ''
        expect(@article).not_to be_valid
      end
    end
    context 'statistics' do
      it 'statisticsが登録できる' do
        @article_statistics = build(:article_statistic)
        expect(@article_statistics).to be_valid
      end
    end
  end
end
