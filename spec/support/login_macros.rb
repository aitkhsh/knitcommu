module LoginMacros
  def login_as(user)
    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    find('input[type="submit"][value="ログイン"]').click
  end
end
