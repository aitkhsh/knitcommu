class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top policy terms user_guide]

  def top; end

  def policy; end

  def terms; end

  def user_guide; end
end
