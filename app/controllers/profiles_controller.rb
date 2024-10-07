class ProfilesController < ApplicationController
  def index
    @profiles = Profile.includes(:user)
  end
end
