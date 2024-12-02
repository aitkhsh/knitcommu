class BoardsController < ApplicationController
  before_action :require_login, only: %i[new create]
  before_action :set_board, only: %i[edit update destroy]
  before_action :set_search_boards_form, only: %i[index search]
  skip_before_action :require_login, only: %i[index show]
  # skip_before_action :prepare_meta_tags, only: :share

  def index
    @boards = if (tag_name = params[:tag_names])
      Board.with_tag(tag_name).page(params[:page])
    else
      Board.includes(:user).page(params[:page])
    end
    # @boards = Board.includes(:user)
  end

  def new
    # セッションをクリア
    session[:title] = nil
    session[:body] = nil
    session[:tag_names] = nil
    session[:image_file_path] = nil
    session[:image_url] = nil

    logger.debug "Session title: #{session[:title]}"
    logger.debug "Session body: #{session[:body]}"
    logger.debug "Session tag_names: #{session[:tag_names]}"
    logger.debug "Session image_file_path: #{session[:image_file_path]}"

    if session[:title].present? && session[:body].present? && session[:tag_names].present?
      @board = Board.new(
        title: session[:title],
        body: session[:body],
      )
      @tag_names = session[:tag_names]
    else
      @board = Board.new
    end
  end

  def create
    # `session[:image_file_path]` に画像パスがあるか確認
    # if session[:image_file_path].present?
    #   # 一時ファイルのパスを開いてCarrierWaveに渡す
    #   image_file = File.open(session[:image_file_path])

    #   if image_file.nil?
    #     flash[:danger] = "画像のダウンロードに失敗しました。再度お試しください。"
    #     redirect_to new_board_path and return
    #   end

    #   # ダウンロードした画像を CarrierWave 経由で保存
    #   @board = Board.new(
    #     title: session[:title],
    #     body: session[:body],
    #     board_image: image_file # 一時ファイルをCarrierWaveの `board_image` にセット
    #     )

    #   if @board.save_with_tags(tag_names: params.dig(:board, :tag_names).split(',').uniq)
    #     # セッションをクリア
    #     session[:title] = nil
    #     session[:body] = nil
    #     session[:tag_names] = nil
    #     session[:image_file_path] = nil

    #     # 一時ファイルを閉じて削除
    #     image_file.close
    #     File.delete(session[:image_file_path]) if File.exist?(session[:image_file_path])

    #     image_file.unlink

    #     redirect_to boards_path, success: t("defaults.flash_message.created", item: Board.model_name.human)
    #   else
    #     flash.now[:danger] = t("defaults.flash_message.not_created", item: Board.model_name.human)
    #     render :new, status: :unprocessable_entity
    #   end
    # else
      # 必要な情報が揃っていない場合、保存用のセッションにリダイレクト
      redirect_to board_sessions_save_path(
        title: params[:board][:title],
        body: params[:board][:body],
        tag_names: params[:board][:tag_names]
      )
    # end
  end

  def show
    @board = Board.find(params[:id])
    @comment = Comment.new
    @comments = @board.comments.includes(:user).order(created_at: :desc)
    # prepare_meta_tags(@board)
    current_time = params[:time]
    # 各投稿の内容に基づいたメタタグ設定
    # メタタグ設定
    set_meta_tags(
      title: "感謝状が届きました💖",
      description: @board.body,
      image: "https://#{ENV['S3_BUCKET_NAME']}.s3.#{ENV['S3_REGION']}.amazonaws.com/#{@board.id}_#{current_time}.png",
      og: {
        title: "感謝状が届きました💖",
        type: "website",
        image: "https://#{ENV['S3_BUCKET_NAME']}.s3.#{ENV['S3_REGION']}.amazonaws.com/#{@board.id}_#{current_time}.png",
        url: request.original_url,
        site_name: "あむ編むコミュ！",
      },
      twitter: {
        card: "summary_large_image",
        site: "@aiaipanick",
        image: "https://#{ENV['S3_BUCKET_NAME']}.s3.#{ENV['S3_REGION']}.amazonaws.com/#{@board.id}_#{current_time}.png",
        title: "感謝状が届きました💖",
        description: @board.body,
      }
    )
  end

  def share
    require 'aws-sdk-s3'

    @board = Board.find(params[:id])
    current_time = Time.now.strftime("%Y%m%d%H%M%S")

    require 'open-uri'
    require 'stringio'

    # 背景画像のパスを指定
    background_path = Rails.root.join('public', 'ogp_image.png')
    canvas = MiniMagick::Image.open(background_path)

    # 背景画像のサイズを取得
    background_width = canvas.width
    background_height = canvas.height


    # ボード画像を取得
    overlay_image_url = @board.board_image.url
    Rails.logger.debug "=== Debug: overlay_image_url: #{overlay_image_url} ==="

    if Rails.env.production?
      # URI.open から画像データを MiniMagick::Image に渡す
      file = URI.open(overlay_image_url) # ファイルストリームを取得
      overlay_image = MiniMagick::Image.read(file.read) # 画像データを読み込む
      Rails.logger.debug "=== Debug: File type: #{file.class}, Path: #{file.path} ==="

    else
      # 開発環境 (publicフォルダ) の場合、publicディレクトリに合わせた絶対パスに変換
      local_path = Rails.root.join("public", overlay_image_url.delete_prefix("/")) # パス先頭の「/」を除去
      overlay_image = MiniMagick::Image.open(File.open(local_path))
    end

    # 1. ボード画像をリサイズ（サイズは固定：500x500）
    overlay_image.resize "700x700"

    # 2. ボード画像を背景画像の中心に配置するための座標を計算
    x_position = (background_width - overlay_image.width) / 2
    y_position = (background_height - overlay_image.height) / 2

    # 3. 透明なベース画像を作成
    base_image = MiniMagick::Tool::Convert.new do |convert|
      convert.size "#{background_width}x#{background_height}"
      convert.canvas "none" # 透明な背景を作成
      convert.format "png"
      convert << "png:-"
    end
    base_image = MiniMagick::Image.read(base_image)

    # 4. ボード画像を透明なキャンバスに配置
    composed_image = base_image.composite(overlay_image) do |c|
      c.geometry "+#{x_position}+#{y_position}" # ボード画像を中央に配置
    end

    # 5. 背景画像を上に配置
    canvas = composed_image.composite(canvas) do |c|
      c.compose "Over" # 背景画像を最前面に配置
    end

    # # 2. 円形に切り抜く（マスク不要）
    # MiniMagick::Tool::Convert.new do |img|
    #   img << overlay_image.path                  # 入力画像
    #   img.alpha "set"                            # アルファチャンネルを有効化
    #   img.background "none"                      # 背景を透明化
    #   img.fill "none"                            # 塗りつぶしを無効化
    #   img.stroke "black"                         # 外部境界線を設定
    #   img.stroke_width "0"                       # ストロークの幅を設定
    #   img.draw "circle 250,250 250,0"            # 中央基準で円形に描画
    #   img.write overlay_image.path               # 上書き保存
    # end



    # # 4. 背景画像に楕円形画像を合成
    # x_position = (background_width - result_image.width) / 2
    # y_position = (background_height - result_image.height) / 2

    # canvas = canvas.composite(result_image) do |c|
    #   c.compose "Over"                          # 上書き合成
    #   c.geometry "+#{x_position}+#{y_position}" # 背景の中央に配置
    # end

    # canvas.write(Rails.root.join('tmp', 'debug_final_image.png'))

    # # 2. 楕円形に加工（透明背景を維持）
    # overlay_image.combine_options do |c|
    #   c.alpha 'set'                             # アルファチャンネルを有効化
    #   c.background 'none'                       # 背景を透明に設定
    #   c.gravity 'center'                        # 中央基準で操作
    #   c.crop '500x500+0+0'                      # 中心を基準に正方形をトリミング
    #   # c.draw 'ellipse 250,250 250,200 0,360'    # 楕円形に切り抜き
    # end


    # # 3. 背景画像に楕円形画像を合成
    # x_position = (background_width - overlay_image.width) / 2
    # y_position = (background_height - overlay_image.height) / 2

    # canvas = canvas.composite(overlay_image) do |c|
    #   c.compose 'Over'                          # 上書き合成
    #   c.geometry "+#{x_position}+#{y_position}" # 背景の中央に配置
    # end



    # # ボード画像を必要に応じてリサイズ
    # overlay_image.resize "500x500" # 例として500x500にリサイズ

    # 中央配置するための座標を計算
    # x_position = (background_width - overlay_image.width) / 2
    # y_position = (background_height - overlay_image.height) / 2

    # # 背景画像の中央にボード画像を合成
    # canvas = canvas.composite(overlay_imagecanvas) do |c|
    #   c.geometry "+#{x_position}+#{y_position}" # 中央に配置
    # end

    # メモリ上に画像を書き込む
    output = StringIO.new
    canvas.write(output)

    # S3リソースを初期化
    s3_resource = Aws::S3::Resource.new(
      region: ENV['S3_REGION'],
      access_key_id: ENV['S3_ACCESS_KEY_ID'],
      secret_access_key: ENV['S3_SECRET_ACCESS_KEY']
    )
    # バケットとオブジェクトキーを設定
    s3_bucket = s3_resource.bucket(ENV['S3_BUCKET_NAME'])
    object_key = "#{@board.id}_#{current_time}.png"


    # 古い画像の削除
    s3_bucket.objects(prefix: "#{@board.id}_").delete

    # 新しい画像のアップロード
    output.rewind # StringIOのポインタを先頭に戻す
    s3_bucket.object(object_key).put(body: output.read, content_type: "image/png")
    uploaded_object = s3_bucket.object(object_key)
    Rails.logger.debug "=== Debug: Object URL: #{uploaded_object.public_url} ==="

    share_image_url = "https://#{ENV['S3_BUCKET_NAME']}.s3.#{ENV['S3_REGION']}.amazonaws.com/#{object_key}"

    set_meta_tags   twitter: {
                    title: "感謝状が届きました💖",
                    card: "summary_large_image",
                    url: "https://amucommu.onrender.com/boards/#{@board.id}?time=#{current_time}",
                    image:  "https://#{ENV['S3_BUCKET_NAME']}.s3.#{ENV['S3_REGION']}.amazonaws.com/#{object_key}"
                  }

    # Twitterシェア用のURL生成
    app_url = "https://amucommu.onrender.com/boards/#{@board.id}?time=#{current_time}"
    default_text = "#感謝状が届きました💖"

    x_url = "https://x.com/intent/tweet?url=#{CGI.escape(app_url)}&text=#{CGI.escape(default_text)}"
    redirect_to x_url, allow_other_host: true
  end

  def edit
    @board = current_user.boards.find(params[:id])
  end

  def update
    @board.assign_attributes(board_params)
    if @board.save_with_tags(tag_names: params.dig(:board, :tag_names).split(',').uniq)
      redirect_to board_path(@board), success: t('defaults.flash_message.updated', item: Board.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: Board.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    board = current_user.boards.find(params[:id])
    board.destroy!
    redirect_to boards_path, success: t('defaults.flash_message.deleted', item: Board.model_name.human), status: :see_other
  end

  def search
    @boards = @search_form.search.includes(:user)
  end

  private

  def board_params
    params.require(:board).permit(:title, :body, :tag_name, :image_url, :image_cache).merge(user_id: current_user.id)
  end

  def set_board
    @board = current_user.boards.find(params[:id])
  end

  def set_search_boards_form
    @search_form = SearchBoardsForm.new(search_board_params)
  end

  def search_board_params
    params.fetch(:q, {}).permit(:title_or_body, :username, :tag)
  end
end

