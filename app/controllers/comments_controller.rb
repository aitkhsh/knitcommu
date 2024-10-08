class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to profile_path(comment.profile), success: t('defaults.flash_message.created', item: Comment.model_name.human)
    else
      redirect_to profile_path(comment.profile), danger: t('defaults.flash_message.not_created', item: Comment.model_name.human)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(profile_id: params[:profile_id])
  end
end