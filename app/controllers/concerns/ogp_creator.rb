class OgpCreator
  require "mini_magick"
  BASE_IMAGE_PATH = "./app/assets/images/ogp_image.png"
  BACKGROUND_IMAGE_PATH = "./public/ogp_image.png"
  GRAVITY = "center"
  TEXT_POSITION = "0,10"
  FONT = "./app/assets/fonts/azuki.ttf"
  FONT_SIZE = 23
  INDENTION_COUNT = 20
  ROW_LIMIT = 8

  def self.build(board)
    return board.ogp.url if board&.ogp.present?

    # # 背景画像を読み込む & リサイズ
    background_image = MiniMagick::Image.open(BACKGROUND_IMAGE_PATH)
    background_image.resize "1200x630"

    # 背景画像のサイズを取得
    background_width = background_image.width
    background_height = background_image.height


    # boardモデルで設定したimage_path（投稿画像）を代入。
    image_path = board.image_path
    # 投稿画像を読み込む
    overlay_image = MiniMagick::Image.open(image_path)
    # 投稿画像をリサイズ
    overlay_image.resize "700x700"


    # 投稿画像を背景画像の中心に配置するための座標を計算
    x_position = (background_width - overlay_image.width) / 2
    y_position = (background_height - overlay_image.height) / 2


    # 背景画像を元にした透明なベース画像を作成
    base_image = MiniMagick::Tool::Convert.new do |convert|
      convert.size "#{background_width}x#{background_height}"
      convert.canvas "none" # 透明な背景を作成
      convert.format "png"
      convert << "png:-"
    end
    base_image = MiniMagick::Image.read(base_image)

    # 投稿画像を透明なキャンバスに配置
    composed_image = base_image.composite(overlay_image) do |c|
      c.geometry "+#{x_position}+#{y_position}" # ボード画像を中央に配置
    end

    # 背景画像を上に配置
    composed_image = composed_image.composite(background_image) do |c|
      c.compose "Over" # 背景画像を最前面に配置
    end

    # 🔹 圧縮（品質を落とさずファイルサイズを削減）
    composed_image.format "jpg"
    composed_image.quality "85"  # 画質を85%に調整
    composed_image.strip # メタデータ削除

    # 生成した画像をCarrierWaveを通じて保存
    temp_file = Tempfile.create([ "ogp", ".jpg" ])
    # image のデータを temp_file.path にあるファイルに書き込む
    composed_image.write(temp_file.path)

    Rails.logger.debug "✅ OGP 画像のファイルサイズ: #{(File.size(temp_file.path).to_f / 1024).round(2)} KB"

    if board
      # CarrierWaveのogp（画像アップロード用のカラム）に一時ファイルを設定
      board.ogp = temp_file
      board.save!
      temp_file.close
      # CarrierWave でアップロードされた画像のURLを取得して返す。
      board.ogp.url
    else
      temp_file.close
      image.path
    end
  end

  private
  def self.prepare_text(text)
    text.to_s.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
  end
end
