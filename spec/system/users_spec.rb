require 'rails_helper'

RSpec.describe "Users", type: :system do
  include LoginMacros
  let(:user) { create(:user) }
  let(:other_user) { create(:user, name: "defg", email: "defg@example.com", password: "password", password_confirmation: "password")}

  describe "ログイン前" do
    context "ユーザー新規登録" do
      it "フォームの入力値が正常で登録成功する" do
        visit login_path
        click_link "新規登録"
        visit new_user_path
        fill_in "名前", with: user.name
        fill_in "メールアドレス", with: "abc@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: "password"
        click_button "登録"
        expect(page).to have_content "ユーザー登録が完了しました"
        expect(current_path).to eq boards_path
      end

      it "メールアドレスが未入力で登録失敗する" do
        visit new_user_path
        fill_in "名前", with: user.name
        fill_in "メールアドレス", with: " "
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: "password"
        click_button "登録"
        expect(page).to have_content "ユーザー登録に失敗しました"
        expect(page).to have_content "メールアドレスを入力してください"
        expect(current_path).to eq new_user_path
      end

      it "登録済みのメールアドレスを入力して登録失敗する" do
        existed_user = create(:user)
        visit new_user_path
        fill_in "名前", with: user.name
        fill_in "メールアドレス", with: existed_user.email
        fill_in "パスワード", with: "password"
        fill_in "パスワード確認", with: "password"
        click_button "登録"
        expect(page).to have_content "ユーザー登録に失敗しました"
        expect(page).to have_content "メールアドレスはすでに存在します"
        expect(current_path).to eq new_user_path
      end
    end

    context "マイページ遷移" do
      it "ログイン前はアクセス失敗する" do
        visit profile_path(user)
        expect(page).to have_content "ログインしてください"
        expect(current_path).to eq(login_path)
      end
    end
  end

  describe "ログイン後" do
    context "ユーザー編集" do
      it "フォームの入力値が正常で編集成功する" do
        login_as(user)
        # ドロップダウンを開く
        find('.btn-circle.avatar').click

        # ドロップダウン内でログアウトリンクをクリック
        within('.dropdown-content') do
          click_link "プロフィール"
        end
        visit profile_path
        click_button "編集"
        visit edit_profile_path(user)
        fill_in "メールアドレス", with: "update@example.com"
        fill_in "名前", with: "update_name"
        click_button "更新"
        expect(page).to have_content "ユーザーを更新しました"
        expect(current_path).to eq(profile_path)
      end

      it "メールアドレスが未入力で編集失敗する" do
        login_as(user)
        # ドロップダウンを開く
        find('.btn-circle.avatar').click

        # ドロップダウン内でログアウトリンクをクリック
        within('.dropdown-content') do
          click_link "プロフィール"
        end
        visit profile_path
        click_button "編集"
        visit edit_profile_path(user)
        fill_in "メールアドレス", with: " "
        fill_in "名前", with: "update_name"
        click_button "更新"
        expect(page).to have_content "ユーザーを更新出来ませんでした"
        expect(page).to have_content "メールアドレスを入力してください"
        expect(current_path).to eq(edit_profile_path(user))
      end

      it "登録済みのメールアドレスを入力し編集失敗する" do
        login_as(user)
        # ドロップダウンを開く
        find('.btn-circle.avatar').click

        # ドロップダウン内でログアウトリンクをクリック
        within('.dropdown-content') do
          click_link "プロフィール"
        end
        visit profile_path
        click_button "編集"
        visit edit_profile_path(user)
        fill_in "メールアドレス", with: other_user.email
        fill_in "名前", with: user.name
        click_button "更新"
        expect(page).to have_content "ユーザーを更新出来ませんでした"
        expect(page).to have_content "メールアドレスはすでに存在します"
        expect(current_path).to eq(edit_profile_path(user))
      end
    end
  end
end
