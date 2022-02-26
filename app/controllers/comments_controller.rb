class CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy]

  def new
    if current_user && Comment.find_by(user_id: current_user.id, article_id: params[:article_id]).present?
      @comment = Comment.find_by(user_id: current_user.id, article_id: params[:article_id])
    else
      @comment = Comment.new
    end
    @comments = Comment.where(article_id: params[:article_id])

    @article = Article.find(params[:article_id])
    
  end

  def create
    # new画面でindex表示させるためのall
    @comments = Comment.where(article_id: params[:article_id])
    @article = Article.find(params[:article_id])

    # ログインしてないと投稿を止める
    return unless user_signed_in?
    # user_idとarticle_idが外部キーのため入れている
    @comment = current_user.comments.build(comment_params)
    @comment[:article_id] = params[:article_id]


    if @comment.save
      redirect_to new_article_comment_path(@comment.article_id), notice: "Comment was successfully created." 
      new_article_comment_path(@comment.article_id)
    else
      render :new
    end
    
  end

  def update
    # 他人がコメント編集できないように
    return if current_user.id != @comment.user_id
    if @comment.update(comment_params)
      redirect_to new_article_comment_path(@comment.article_id), notice: "Comment was successfully created." 
      new_article_comment_path(@comment.article_id)
    else
      @comments = Comment.where(article_id: params[:article_id])
      @article = Article.find(params[:article_id])
      render :new
    end
  end

  def destroy
    # 他人がコメント編集できないように
    return if current_user.id != @comment.user_id

    @comment.destroy

    respond_to do |format|
      format.html { redirect_to new_article_comment_path, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
