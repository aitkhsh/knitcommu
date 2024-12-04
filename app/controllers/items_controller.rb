class ItemsController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  def index
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      if @user.nil?
        redirect_to boards_path, alert: "ユーザーが見つかりません。" and return
      end
    else
      @user = current_user
    end
      # ユーザーに紐付いた user_items を取得
      @user_items = @user.user_items.includes(:item) if @user
  end
end
