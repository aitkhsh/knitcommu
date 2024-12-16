require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "バリデーションチェック" do
    it "設定したすべてのバリデーションが機能しているか" do
      tag = build(:tag)
      expect(tag).to be_valid
      expect(tag.errors).to be_empty
    end
    it "nameがない場合にバリデーションが機能してinvalidになるか" do
      tag_without_name = build(:tag, name: "")
      expect(tag_without_name).to be_invalid
      expect(tag_without_name.errors[:name]).to eq [ "を入力してください" ]
    end
    it "同じnameが入力されたらバリデーションが機能してinvalidになるか" do
      tag = create(:tag, name: "abcd")
      new_tag = build(:tag, name: "abcd")
      expect(new_tag).to be_invalid
      expect(new_tag.errors[:name]).to eq [ "はすでに存在します" ]
    end
  end
end
