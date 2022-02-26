class ArticlesController < ApplicationController

  def index

    # 記事の並び替えアルゴリズム
    article = Article.new
    @articles = article.sort_article(params)

    # セレクトボックス
    @selectbox_time = params[:time] 
    @selectbox_sort_algorithm = params[:sort_algorithm]

  end

  # 手動スクレイピング機能（念の為）
  def create
    if params[:name].present?
      p ArticleStatistic.scraping_yahoo(params[:name].to_i)
    end
    redirect_to articles_path

  end
end
