module ApplicationHelper
  def page_title(title = "")
    base_title = "AMUCOMMU"
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-green-400"
    when :alert  then "bg-red-400"
    when :error  then "bg-yellow-500"
    else "bg-gray-500"
    end
  end

  def default_meta_tags
    {
      site: "あむ編むコミュ！",
      title: "あむ編むコミュ！",
      reverse: true,
      charset: 'utf-8',
      description: "「感謝の気持ち」を表現し、相手が喜ぶ画像をAIで生成してプレゼントするアプリ",
      og: {
        site_name: "あむ編むコミュ！",
        title: "あむ編むコミュ！",
        description: "「感謝の気持ち」を表現し、相手が喜ぶ画像をAIで生成してプレゼントするアプリ",
        type: "website",
        url: request.original_url,
        # アセットパイプラインを利用してURLを生成する必要があり、asset_url または asset_path を使用して絶対URLを作成。
        # image: ActionController::Base.helpers.asset_url("ogp_image.png?v=#{Time.now.to_i}", host: request.base_url)
        image: image_url("ogp_image.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@aiaipanick", # 任意でTwitterアカウントを指定
        # image: ActionController::Base.helpers.asset_url("ogp_image.png?v=#{Time.now.to_i}", host: request.base_url)
        image: image_url("ogp_image.png"),
      }
    }
  end
end
