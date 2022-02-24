class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index


    if params[:time] == "3"
      # 記事作成日時が全て
      @articles = Article.all
      @display_the_title = '総合ランキング'
    elsif params[:time] == "2"
      # 記事作成日時が1週間以内のもので絞り込み
      @articles = Article.where_1week_articles
      @display_the_title = '1週間のランキング'
    else
      # 記事作成日時が24時間以内のもので絞り込み
      @articles = Article.where_24hour_articles
      @display_the_title = '24時間ランキング'
    end

    if params[:sort_algorithm] == '1'
      # 記事内コメント順で降順
      @articles = @articles.order_comment
    elsif params[:sort_algorithm] == '2'
      # 記事内いいね順で降順
      @articles = @articles.order_fav
    else
      # 記事内favとcomment数を合算して1記事ごとに反響の総数を計算している
      @articles.each do |article|
        num = article.article_statistic.fav + article.article_statistic.comment
        article[:ranking] = num
      end

      # # 記事内反響の総数順で降順
      @articles = @articles.sort_by { |x| x[:ranking] }.reverse
    end

    # 記事内favとcomment数を合算して1記事ごとに反響の総数を計算している（sort_algorithmが3の時用、要リファクタリング）
    @articles.each do |article|
      num = article.article_statistic.fav + article.article_statistic.comment
      article[:ranking] = num
    end

    @time = params[:time]
    @sort_algorithm = params[:sort_algorithm]

    # kaminari、array用仕様
    @articles = Kaminari.paginate_array(@articles).page(params[:page]).per(30)

  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    if params[:name].present?
      p ArticleStatistic.scraping_yahoo("https://news.yahoo.co.jp/topics/top-picks?page=#{params[:name].to_i}")
    end
    # @article = Article.new(article_params)
    redirect_to articles_path

    # respond_to do |format|
    #   if @article.save
    #     format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
    #     format.json { render :show, status: :created, location: @article }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @article.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :link, :icon, :ranking)
    end
end
