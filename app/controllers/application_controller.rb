class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :require_login
  add_flash_types :success, :danger
  before_action :prepare_meta_tags, if: -> { request.get? }

  private

  def not_authenticated
    redirect_to login_path, danger: t("defaults.flash_message.require_login")
  end

  def prepare_meta_tags(options = {})
    defaults = {
      site: "あむ編むコミュ！",
      title: "あむ編むコミュ！",
      description: "「感謝の気持ち」を表現し、相手が喜ぶ画像をAIで生成してプレゼントするアプリ",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: :current_url,
        image: "https://amucommu.onrender.com/ogp_image.png"
      },
      twitter: {
        card: "summary_large_image",
        site: "@aiaipanick", # 任意でTwitterアカウントを指定
        image: "https://amucommu.onrender.com/ogp_image.png"
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end
end

