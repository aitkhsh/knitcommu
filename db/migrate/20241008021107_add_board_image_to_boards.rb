class AddBoardImageToBoards < ActiveRecord::Migration[7.2]
  def change
    add_column :boards, :board_image, :string
  end
end
