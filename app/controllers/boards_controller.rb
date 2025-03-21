class BoardsController < ApplicationController
  before_action :require_login, only: %i[new create edit update]
  before_action :set_board, only: %i[edit update]
  before_action :set_search_boards_form, only: %i[index search]
  skip_before_action :require_login, only: %i[index show]
  before_action :check_board_limit, only: %i[new create]
  ## 設定したprepare_meta_tagsをprivateにあってもpostコントローラー以外にも使えるようにする
  helper_method :prepare_meta_tags

  def index
    @boards = if (tag_name = params[:tag_name])
      Board.with_tag(tag_name).order(created_at: :desc).page(params[:page])
    else
      Board.includes(:user).order(created_at: :desc).page(params[:page])
    end
  end

  def new
    # セッションをクリア
    session[:title] = nil
    session[:body] = nil
    session[:tag_names] = nil
    session[:image_file_path] = nil
    session[:image_url] = nil

    # 値の有無をチェック
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
    prepare_meta_tags(@board)
  end

  def edit
    @board = current_user.boards.find(params[:id])
  end

  def update
    @board.assign_attributes(board_params)
    if @board.save_with_tags(tag_names: params.dig(:board, :tag_names).split("、").uniq)
      redirect_to board_path(@board), notice: t("defaults.flash_message.updated", item: Board.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_updated", item: Board.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  # 感謝状削除機能保留
  # def destroy
  #   board = current_user.boards.find(params[:id])
  #   board.destroy!
  #   redirect_to boards_path, notice: t("defaults.flash_message.deleted", item: Board.model_name.human), status: :see_other
  # end

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
    params.fetch(:q, {}).permit(:title_or_body, :name, :tag)
  end

  def check_board_limit
    max_boards_per_month = 2
    if Board.this_month_boards_count(current_user) >= max_boards_per_month
      redirect_to boards_path, alert: "1ヶ月に投稿できる数は最大#{max_boards_per_month}件までです。"
    end
  end

  def prepare_meta_tags(board)
    # image_url = "#{request.base_url}#{OgpCreator.build(board)}?t=#{Time.now.to_i}"
    image_url = OgpCreator.build(board)

    set_meta_tags og: {
                    site_name: "あむ編むコミュ！",
                    title: "届け感謝状💖",
                    type: "website",
                    url: request.original_url,
                    image: image_url,
                    locale: "ja-JP"
                  },
                  twitter: {
                    card: "summary_large_image",
                    site: "@aiaipanick",
                    image: image_url
                  }
  end
end
