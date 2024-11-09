class PicturesController < ApplicationController
  MAX_IMAGES = 3 # 最大生成枚数を定数として定義

  def create
    # 最初の画像生成リクエストの場合のみセッションをクリア
    if session[:image_urls].nil? || session[:image_urls].empty?
      session[:image_urls] = []
      session[:image_url] = nil
    end
    # フォーム送信で画像生成がリクエストされた場合
    if params[:body].present? && params[:tag_names].present?
      # ユーザーの入力をセッションに保存（必ず上書きするように修正）
      session[:title] = params[:title]
      session[:body] = params[:body]
      session[:tag_names] = params[:tag_names]

      if session[:image_urls].size < MAX_IMAGES
        # プロンプトを生成して画像を生成
        prompt = params[:tag_names]
        response = OpenAiService.generate_image(prompt)
        # puts response.body

        if response.key?("error")
          session[:error] = response["error"]
        elsif response["data"].present?
          # 複数の画像URLをセッションに保存
          session[:image_urls] ||= []
          response["data"].each do |data|
            session[:image_urls] << data["url"]
          end

          # 画像が3つ生成されたか確認
          if session[:image_urls].size == MAX_IMAGES
            session[:error] = nil
            flash[:notice] = "画像が全て生成されました！"
            redirect_to pictures_path and return
          else
            flash[:notice] = "画像が生成されました。最大で#{MAX_IMAGES}枚まで画像を生成できます。"
          end
        end
      else
        flash[:notice] = "最大で#{MAX_IMAGES}枚までしか生成できません。"
      end
    else
      flash[:notice] = "値がありません"
    end
    redirect_to pictures_path
  end

  def index
    @images = session[:image_urls] || []
    @title = session[:title]
    @body = session[:body]
    @tag = session[:tag_names]
    @error = session[:error]
  end

  def select_image
    # ユーザーが選択した画像URLをセッションに保存

    if params[:image_url].present? && params[:title].present? && params[:body].present? && params[:tag_names].present?

      # # 選択された画像URLを session[:image_url] に保存し、他の画像URLは破棄
      session[:image_url] = params[:image_url]
      session[:image_urls] = nil
      flash[:notice] = "画像が選択されました！"
      # 画像URLから画像をダウンロード
      image_file = OpenAiService.download_image_from_url(params[:image_url])

      # image_fileが正しく取得できているかチェック
      if image_file.nil? || !image_file.respond_to?(:path)
        flash[:alert] = "画像のダウンロードに失敗しました。再度お試しください。"
        redirect_to pictures_path and return
      end

      # ファイルを再度読み込みCarrierWaveに渡す
      # file_for_upload = File.open(image_file.path)

      # Boardレコードを作成し、画像や他の情報も保存
      board = Board.new(
        title: params[:title],
        body: params[:body],
        board_image: image_file, # Tempfileを直接CarrierWaveに渡す
        user: current_user # 投稿者を設定
      )

      if board.save_with_tags(tag_names: params[:tag_names].split(',').map(&:strip))
        # 一時ファイルを削除
        image_file.close
        image_file.unlink

        flash[:notice] = "Boardが作成されました！"
        redirect_to board_path(board)
      else
        flash[:alert] = "Boardの保存に失敗しました。再度お試しください。"
        redirect_to pictures_path
      end
    else
      flash[:alert] = "タイトル、本文、タグ、または画像が不足しています。"
      redirect_to pictures_path
    end
  end

  private
  def picture_params
    params.permit(:body, :tag_names)
  end

end