require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    it "設定したすべてのバリデーションが機能しているか" do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end
    it "emailがない場合にバリデーションが機能してinvalidになるか" do
      user_without_email = build(:user, email:"")
      expect(user_without_email).to be_invalid
      expect(user_without_email.errors[:email]).to eq ["を入力してください"]
    end
    it "同じemailが入力されたらバリデーションが機能してinvalidになるか" do
      user = create(:user, email:"existing.example.com")
      new_user = build(:user, email:"existing.example.com")
      expect(new_user).to be_invalid
      expect(new_user.errors[:email]).to eq ["はすでに存在します"]
    end
    it "passwordがない場合にバリデーションが機能してinvalidになるか" do
      user_without_password = build(:user, password:"")
      expect(user_without_password).to be_invalid
      expect(user_without_password.errors[:password]).to eq ["は3文字以上で入力してください"]
    end
    it "password_confirmationがない場合にバリデーションが機能してinvalidになるか" do
      user_without_password_confirmation = build(:user, password_confirmation:"")
      expect(user_without_password_confirmation).to be_invalid
      expect(user_without_password_confirmation.errors[:password_confirmation]).to eq ["とパスワードの入力が一致しません", "を入力してください"]
    end
    it "passwordが3文字以内の場合にバリデーションが機能してinvalidになるか" do
      user_less_than_three_password = build(:user, password:"ab")
      expect(user_less_than_three_password).to be_invalid
      expect(user_less_than_three_password.errors[:password]).to eq ["は3文字以上で入力してください"]
    end
    it "nameがない場合にバリデーションが機能してinvalidになるか" do
      user_without_name = build(:user, name:"")
      expect(user_without_name).to be_invalid
      expect(user_without_name.errors[:name]).to eq ["を入力してください"]
    end
  end
end