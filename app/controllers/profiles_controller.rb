class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: t("defaults.flash_message.updated", item: User.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_updated", item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除機能保留
  # def destroy
  #   @user = current_user
  #   @user.destroy
  #   reset_session
  #   redirect_to root_path, status: :see_other, notice: t("defaults.flash_message.destroy")
  # end

  private
  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :avatar_cache)
  end
end
