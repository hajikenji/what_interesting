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

describe 'スコープテスト' do
    before do
      50.times do 
        create(:article_statistic)
      end
      @big = create(:article_statistic)
      @big.update(comment: 10000, fav: 10000)
      @middle = create(:article_statistic)
      @middle.update(comment: 9000, fav: 9000)
      @small = create(:article_statistic)
      @small.update(comment: 1, fav: 1)
    end
    context 'order系' do
      it '（factorybot定義よりも）一番でかいの、2番目にでかいの、一番小さいのを挿入してちゃんと並んでいるか' do
        @articles = Article.order_comment
        expect(@big.comment).to eq @articles.first.article_statistic.comment
        expect(@middle.comment).to eq @articles.order_comment.all[1].article_statistic.comment
        expect(@small.comment).to eq @articles.order_comment.last.article_statistic.comment
      end
      it 'order_fav' do
        @articles = Article.order_fav
        expect(@big.fav).to eq @articles.first.article_statistic.fav
        expect(@middle.fav).to eq @articles.all[1].article_statistic.fav
        expect(@small.fav).to eq @articles.last.article_statistic.fav
      end
    end
    context '時間系' do
      before do
        @big = @big.article
        @big.update(created_at: Time.now)
        @middle = @middle.article
        @middle.update(created_at: Time.now.ago(3.days))
        @small = @small.article
        @small.update(created_at: Time.now.ago(10.days))
      end
      it 'where_24hour_articles' do
        @articles = Article.where_24hour_articles
        expect(@articles.find(@big.id)).to eq @big
        expect(@articles.find_by(id: @middle.id)).not_to eq @middle
        expect(@articles.find_by(id: @small.id)).not_to eq @small
      end
      it 'where_1week_articles' do
        @articles = Article.where_1week_articles
        expect(@articles.find(@big.id)).to eq @big
        expect(@articles.find(@middle.id)).to eq @middle
        expect(@articles.find_by(id: @small.id)).not_to eq @small
      end
    end
  end