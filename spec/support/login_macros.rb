module LoginMacros
  def login(user)
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_on "ログイン"
  end
end
