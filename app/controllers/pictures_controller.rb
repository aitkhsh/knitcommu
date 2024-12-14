class PicturesController < ApplicationController
  MAX_IMAGES = 2 # 最大生成枚数を定数として定義
  before_action :check_board_limit, only: %i[index create]

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

      # Boardレコードを作成し、画像や他の情報も保存
      board = Board.new(
        title: params[:title],
        body: params[:body],
        board_image: image_file, # Tempfileを直接CarrierWaveに渡す
        user: current_user # 投稿者を設定
      )

      if board.save_with_tags(tag_names: params[:tag_names].split("、").map(&:strip))
        # 一時ファイルを削除
        image_file.close
        image_file.unlink
        # 投稿数を計算
        check_for_reward(current_user)

        flash[:notice] = "感謝状が作成されました！"
        redirect_to board_path(board)
      else
        flash[:alert] = "感謝状の保存に失敗しました。再度お試しください。"
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

  def check_for_reward(current_user)
    # リリース初期段階で Item モデルにバッジを登録
    # リリース数日後にコメントアウト予定
    bedges = [ "badge1.png", "badge2.png", "badge3.png", "badge4.png", "badge5.png", "badge6.png", "badge7.png", "badge8.png", "badge9.png", "badge10.png", "badge11.png", "badge12.png", "badge13.png" ]

    bedges.each do |image|
      Item.find_or_create_by!(
        image: image
        )
    end

    # 報酬バッジをユーザーに付与
    total_batch_count = current_user.boards.count / 3

    # 既に付与済みのバッジ数を取得
    existing_batch_count = current_user.user_items.count

    # 新たに付与すべきバッジ数を計算
    new_batch_count = total_batch_count - existing_batch_count

    if new_batch_count >= 1
      new_batch_count.times do
        # ランダムにアイテムを選択
        item_id = Item.pluck(:id).sample # 登録されているアイテムのIDからランダムに取得
        UserItem.create!(user_id: current_user.id, item_id: item_id)
        flash[:notice] = "アイテムを獲得しました！アイテム一覧を確認しましょう！"
        redirect_to items_path
      end
    end
  end

  def check_board_limit
    max_boards_per_month = 2
    if Board.this_month_boards_count(current_user) > max_boards_per_month
      redirect_to boards_path, alert: "1ヶ月に投稿できる数は最大#{max_boards_per_month}件までです。"
    end
  end
end
