require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe "ログイン前" do
    context "ユーザー新規登録" do
      it "フォームの入力値が正常で登録成功する" do
        visit login_path
        click_link "新規登録"
        visit new_user_path
        fill_in "名前", with: user.name
        fill_in "メールアドレス", with: user.name
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: "password"
        click_button "登録"
        expect(page).to have_content "ユーザー登録が完了しました"
        expect(current_path).to eq boards_path
      end
    end
  end
end
