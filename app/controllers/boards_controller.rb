class BoardsController < ApplicationController
  before_action :require_login, only: %i[new create]
  before_action :set_board, only: %i[edit update destroy]
  before_action :set_search_boards_form, only: %i[index search]
  skip_before_action :require_login, only: %i[index show]
  helper_method :prepare_meta_tags

  def index
    @boards = if (tag_name = params[:tag_names])
      Board.with_tag(tag_name)
    else
      Board.includes(:user)
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
