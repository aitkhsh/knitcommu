class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(params[:provider])
    puts "---------------"
  puts "2 ok"
  puts "---------------"
  end

  # def oauth
  #   redirect_to sorcery_login_url(params[:provider]), allow_other_host: true
  # end

  def callback
    provider = params[:provider]
    pp provider

    puts "---------------"
    puts "1 ok"
    puts "---------------"

    if params[:error]
      redirect_to root_path, alert: t('alerts.auth.cancelled', provider: provider.titleize)
      return
    end

    if @user = login_from(provider)
      redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました。"
      puts "---------------"
      puts "3 ok"
      puts "---------------"
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path, success: "#{provider.titleize}アカウントでログインしました。"
      rescue
        redirect_to root_path, error: "#{provider.titleize}アカウントでのログインに失敗しました。"
      end
    end
  end
end
