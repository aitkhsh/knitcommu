class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :require_login
  # add_flash_types :success, :danger
  # before_action :prepare_meta_tags, if: -> { request.get? }

  private

  # def not_authenticated
  #   redirect_to login_path, danger: t("defaults.flash_message.require_login")
  # end
  def not_authenticated
    redirect_to login_path, alert: t("defaults.flash_message.require_login")
  end

  # def prepare_meta_tags(options = {})
  #   defaults = {
  #     site: "あむ編むコミュ！",
  #     title: "あむ編むコミュ！",
  #     description: "「感謝の気持ち」を表現し、相手が喜ぶ画像をAIで生成してプレゼントするアプリ",
  #     og: {
  #       site_name: :site,
  #       title: :title,
  #       description: :description,
  #       type: "website",
  #       url: :current_url,
  #       # アセットパイプラインを利用してURLを生成する必要があり、asset_url または asset_path を使用して絶対URLを作成。
  #       image: ActionController::Base.helpers.asset_url("ogp_image.png?v=#{Time.now.to_i}", host: request.base_url)
  #     },
  #     twitter: {
  #       card: "summary_large_image",
  #       site: "@aiaipanick", # 任意でTwitterアカウントを指定
  #       image: ActionController::Base.helpers.asset_url("ogp_image.png?v=#{Time.now.to_i}", host: request.base_url)
  #     }
  #   }

  #   options.reverse_merge!(defaults)

  #   set_meta_tags options
  # end
end
