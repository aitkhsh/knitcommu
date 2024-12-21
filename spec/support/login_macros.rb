module LoginMacros
  def login_as(user)
    visit root_path
    click_link "ログイン"
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"
    expect(page).to have_content "ログインしました"
    expect(current_path).to eq boards_path
  end
end
