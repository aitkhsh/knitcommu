require 'rails_helper'

RSpec.describe "Boards", type: :system do
  include LoginMacros
  let(:user) { create(:user) }
  let(:board) { create(:board, user: user) } # BoardにUserを紐づける
  describe "ログイン前" do
    context "感謝状の新規作成ページにアクセスする" do
      it "失敗する" do
        visit new_board_path
        expect(page).to have_content "ログインしてください"
        expect(current_path).to eq(login_path)
      end
    end

    context "感謝状の編集ページにアクセスする" do
      it "失敗する" do
        visit edit_board_path(board) # ダミーBoardのIDを渡してアクセス
        expect(page).to have_content "ログインしてください"
        expect(current_path).to eq(login_path)
      end
    end

    it "感謝状の一覧ページにアクセスすると感謝状一覧が表示される" do
      board = create(:board) # 先にBoardを作成
      visit boards_path # 一覧ページにアクセス
      expect(page).to have_content board.title
      expect(page).to have_content board.body
      expect(current_path).to eq boards_path
    end
  end

  describe "ログイン後" do
    before do
      Capybara.reset_sessions! # セッションのリセット
      login_as(user)
    end
    context "感謝状の新規作成ページにアクセスする" do
      it "成功する" do
        click_link "感謝状作成"
        expect(page).to have_field "感謝を伝えたい人の名前"
        expect(page).to have_field "感謝メッセージ"
        expect(page).to have_field "相手のイメージキーワード"
        expect(page).to have_button "登録"
        expect(current_path).to eq(new_board_path)
      end
    end

    context "感謝状の編集ページにアクセスする" do
      it "成功する" do
        visit edit_board_path(board) # ダミーBoardのIDを渡してアクセス
        expect(page).to have_field "感謝を伝えたい人の名前"
        expect(page).to have_field "感謝メッセージ"
        expect(page).to have_field "相手のイメージキーワード"
        expect(page).to have_button "更新"
        expect(current_path).to eq(edit_board_path(board))
      end

      it "フォームの入力値が正常で、タスクの編集が成功する" do
        visit edit_board_path(board) # ダミーBoardのIDを渡してアクセス
        fill_in "感謝を伝えたい人の名前", with: "Update_name"
        fill_in "感謝メッセージ", with: "Update_body"
        fill_in "相手のイメージキーワード", with: "Update_tag"
        click_button "更新"
        expect(page).to have_content "感謝状を更新しました"
        expect(current_path).to eq(board_path(board))
      end

      it "「感謝を伝えたい人の名前」が未入力で、タスクの編集が失敗する" do
        visit edit_board_path(board) # ダミーBoardのIDを渡してアクセス
        fill_in "感謝を伝えたい人の名前", with: " "
        fill_in "感謝メッセージ", with: "Update_body"
        fill_in "相手のイメージキーワード", with: "Update_tag"
        click_button "更新"
        expect(page).to have_content "感謝状を更新出来ませんでした"
        expect(current_path).to eq(edit_board_path(board))
      end

      it "「感謝メッセージ」が未入力で、タスクの編集が失敗する" do
        visit edit_board_path(board) # ダミーBoardのIDを渡してアクセス
        fill_in "感謝を伝えたい人の名前", with: "Update_name"
        fill_in "感謝メッセージ", with: " "
        fill_in "相手のイメージキーワード", with: "Update_tag"
        click_button "更新"
        expect(page).to have_content "感謝状を更新出来ませんでした"
        expect(current_path).to eq(edit_board_path(board))
      end

      it "「感謝メッセージ」が未入力で、タスクの編集が失敗する" do
        visit edit_board_path(board) # ダミーBoardのIDを渡してアクセス
        fill_in "感謝を伝えたい人の名前", with: "Update_name"
        fill_in "感謝メッセージ", with: "Update_body"
        fill_in "相手のイメージキーワード", with: " "
        click_button "更新"
        expect(page).to have_content "感謝状を更新出来ませんでした"
        expect(current_path).to eq(edit_board_path(board))
      end
    end

    it "感謝状の一覧ページにアクセスすると感謝状一覧が表示される" do
      board = create(:board) # 先にBoardを作成
      visit boards_path # 一覧ページにアクセス
      expect(page).to have_content board.title
      expect(page).to have_content board.body
      expect(current_path).to eq boards_path
    end
  end
end
