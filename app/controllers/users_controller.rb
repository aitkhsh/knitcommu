class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to boards_path, success: t("users.create.success")
    else
      flash.now[:danger] = t("users.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    # ユーザーに紐付いた user_items を取得
    @user_items = @user.user_items.includes(:item)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :tweet_id)
  end
end
