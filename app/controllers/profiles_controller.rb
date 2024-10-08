class ProfilesController < ApplicationController
  def index
    @profiles = Profile.includes(:user)
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.profiles.build(profile_params)
    if @profile.save
      redirect_to profiles_path, success: t("defaults.flash_message.created", item: Profile.model_name.human)
    else
      flash.now[:danger] = t("defaults.flash_message.not_created", item: Profile.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def edit
    @profile = current_user.profiles.find(params[:id])
  end

  def update
    @profile = current_user.profiles.find(params[:id])
    if @profile.update(profile_params)
      redirect_to profile_path(@profile), success: t('defaults.flash_message.updated', item: Profile.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: Profile.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    profile = current_user.profiles.find(params[:id])
    profile.destroy!
    redirect_to profiles_path, success: t('defaults.flash_message.deleted', item: Profile.model_name.human), status: :see_other
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :body, :profile_image, :profile_image_cache).merge(user_id: current_user.id)
  end
end
