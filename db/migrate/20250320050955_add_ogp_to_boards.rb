class AddOgpToBoards < ActiveRecord::Migration[7.2]
  def change
    add_column :boards, :ogp, :string
  end
end
