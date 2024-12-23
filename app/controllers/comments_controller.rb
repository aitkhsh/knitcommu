class CommentsController < ApplicationController
  helper_method :prepare_meta_tags
  skip_before_action :require_login, only: %i[show]

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to comment_path(@comment.id), notice: t("defaults.flash_message.created", item: Comment.model_name.human)
    else
      redirect_to board_path(@comment.board), alert: t("defaults.flash_message.not_created", item: Comment.model_name.human)
    end
  end

  def show
    @board = Board.find(params[:id])
    @comment = Comment.find(params[:id])  # ボードに関連するコメントを取得
    # prepare_meta_tags(@comment) #ここで渡された引数が、下記のprepare_meta_tagsアクションにいく。
    @comments = @board.comments.includes(:user).order(created_at: :desc)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(board_id: params[:board_id])
  end
end
