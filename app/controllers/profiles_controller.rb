class ProfilesController < ApplicationController
  before_action :require_login, only: %i[new create]
  before_action :set_profile, only: %i[edit update destroy]
  before_action :set_search_profiles_form, only: %i[index search]
  skip_before_action :require_login, only: %i[index show]
  helper_method :prepare_meta_tags

  def index
    @profiles = if (tag_name = params[:tag_name])
      Profile.with_tag(tag_name)
    else
      Profile.includes(:user)
    end
    # @profiles = Profile.includes(:user)
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.profiles.new(profile_params)
    if @profile.save_with_tags(tag_names: params.dig(:profile, :tag_names).split(',').uniq)
      redirect_to profiles_path, success: t("defaults.flash_message.created", item: Profile.model_name.human)
    else
      flash.now[:danger] = t("defaults.flash_message.not_created", item: Profile.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @profile = Profile.find(params[:id])
    @comment = Comment.new
    @comments = @profile.comments.includes(:user).order(created_at: :desc)
  end

  def edit
    @profile = current_user.profiles.find(params[:id])
  end

  def update
    @post.assign_attributes(post_params)
    if @profile.save_with_tags(tag_names: params.dig(:profile, :tag_names).split(',').uniq)
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

  def search
    @profiles = @search_form.search.includes(:user)
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :body, :profile_image, :profile_image_cache).merge(user_id: current_user.id)
  end

  def set_profile
    @profile = current_user.profiles.find(params[:id])
  end

  def set_search_profiles_form
    @search_form = SearchProfilesForm.new(search_profile_params)
  end

  def search_profile_params
    params.fetch(:q, {}).permit(:name_or_body, :username, :tag)
  end
end
