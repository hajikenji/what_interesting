class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index

    if params[:value] == 'all_time_ranking'
      # 記事内いいね順で降順
      @articles = Article.order_fav
    elsif params[:value] == '24hour_time_ranking'
      # 
      @articles = Article.where_today_articles
      # 記事内いいね順で降順
      @articles = @articles.order_fav
    else
      @articles = Article.where_today_articles
      @articles = @articles.order_fav
    end

    
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
    @article = Article.new(article_params)

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
