class CreateBoardtags < ActiveRecord::Migration[7.2]
  def change
    create_table :boardtags do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
    add_index :boardtags, [ :tag_id, :board_id ], unique: true
  end
end
