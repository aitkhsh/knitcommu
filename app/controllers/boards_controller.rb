class BoardsController < ApplicationController
  before_action :require_login, only: %i[new create]
  before_action :set_board, only: %i[edit update destroy]
  before_action :set_search_boards_form, only: %i[index search]
  skip_before_action :require_login, only: %i[index show]
  helper_method :prepare_meta_tags

  def index
    @boards = if (tag_name = params[:tag_name])
      Board.with_tag(tag_name)
    else
      Board.includes(:user)
    end
    # @profiles = Profile.includes(:user)
  end

  def new
    @board = Board.new
  end

  def create
    @board = current_user.boards.new(board_params)
    if @board.save_with_tags(tag_names: params.dig(:board, :tag_names).split(',').uniq)
      redirect_to boards_path, success: t("defaults.flash_message.created", item: Board.model_name.human)
    else
      flash.now[:danger] = t("defaults.flash_message.not_created", item: Board.model_name.human)
      render :new, status: :unprocessable_entity
    end
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
    profile = current_user.boards.find(params[:id])
    profile.destroy!
    redirect_to boards_path, success: t('defaults.flash_message.deleted', item: Board.model_name.human), status: :see_other
  end

  def search
    @boards = @search_form.search.includes(:user)
  end

  private

  def board_params
    params.require(:board).permit(:title, :body, :board_image, :board_image_cache).merge(user_id: current_user.id)
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
