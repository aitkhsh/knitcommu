require 'rails_helper'

RSpec.describe "LoginMacros Test", type: :system do
  include LoginMacros

  it "can call login_as method" do
    user = FactoryBot.create(:user, email: "test@example.com", password: "password")
    login_as(user) # LoginMacros のメソッドを呼び出す

    expect(page).to have_content "ログインしました" # 正しいフラッシュメッセージを確認
  end
end
