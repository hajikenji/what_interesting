class Article < ApplicationRecord
  has_one :article_statistic, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :link, presence: true

  scope :order_fav, -> { eager_load(:article_statistic).order(fav: "DESC") }
  scope :order_comment, -> { eager_load(:article_statistic).order(comment: "DESC") }
  scope :where_24hour_articles, -> { where(created_at: Time.now.yesterday..Time.now) }
  scope :where_1week_articles, -> { where(created_at: Time.now.ago(7.days)..Time.now) }

  # 並び替えアルゴリズムの部分
  def sort_article(params)
    # 時間で絞り込みをするメソッド
    articles_by_time = filter_by_time(params[:time])
    # いいね順、コメント順などでソートするメソッド
    articles = filter_by_sort_algorithm(articles_by_time, params[:sort_algorithm])
    # kaminari、array用仕様
    Kaminari.paginate_array(articles).page(params[:page]).per(100)
  end

  # 上述のアルゴリズムを詳しく設定しているコードが下記
  def filter_by_time(params_time)
    if params_time == "all_time"
      # 記事作成日時が全て
      @articles_by_time = Article.all
    elsif params_time == "1_week"
      # 記事作成日時が1週間以内のもので絞り込み
      @articles_by_time = Article.where_1week_articles
    else
      # 記事作成日時が24時間以内のもので絞り込み
      @articles_by_time = Article.where_24hour_articles
    end
  end

  def filter_by_sort_algorithm(articles_by_time, params_sort_algorithm)
    if params_sort_algorithm == 'comment'
      # 記事内コメント順で降順
      articles = articles_by_time.order_comment
    elsif params_sort_algorithm == 'fav'
      # 記事内いいね順で降順
      articles = articles_by_time.order_fav
    else
      # 記事内favとcomment数を合算して1記事ごとに反響の総数を計算している
      articles_by_time.each do |article|
        num = article.article_statistic.fav + article.article_statistic.comment
        article[:ranking] = num
      end

      # # 記事内反響の総数順で降順
      articles = articles_by_time.sort_by { |x| x[:ranking] }.reverse
    end
     # 反響の総数メソッドと同じ。最後に行う必要があるためここにあるが、
     # 「反響の総数順」メソッドの前に行う必要があるため、else文の中でも登場している
    articles.each do |article|
      num = article.article_statistic.fav + article.article_statistic.comment
      article[:ranking] = num
    end
  end

end
