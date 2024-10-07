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

  private

  def profile_params
    params.require(:profile).permit(:name, :body)
  end
end
