class ProfilesController < ApplicationController
  def index
    @profiles = Profile.includes(:user)
  end

  def new
    @profile = Profile.new
  end
end
