require "rails_helper"

RSpec.describe Board, type: :model do
  describe "バリデーションチェック" do
    it "設定したすべてのバリデーションが機能しているか" do
      board = build(:board)
      expect(board).to be_valid
      expect(board.errors).to be_empty
    end
    it "titleがない場合にバリデーションが機能してinvalidになるか" do
      board_without_title = build(:board, title: "")
      expect(board_without_title).to be_invalid
      expect(board_without_title.errors[:title]).to eq [ "を入力してください" ]
    end
    it "bodyがない場合にバリデーションが機能してinvalidになるか" do
      board_without_body = build(:board, body: "")
      expect(board_without_body).to be_invalid
      expect(board_without_body.errors[:body]).to eq [ "を入力してください" ]
    end
    it "imageがない場合にバリデーションが機能してinvalidになるか" do
      # 保留
    end
  end
end
