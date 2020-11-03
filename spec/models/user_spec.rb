require "rails_helper"

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "作成するユーザー情報がすべて揃っている" do
    let(:user) { build(:user) }
    it "ユーザーが作成される" do
      expect(user).to be_valid
    end
  end

  context "すでに同じユーザー名が使用されている" do
    before { create(:user, name: "foo") }

    let(:user) { build(:user, name: "foo") }
    it "ユーザーの作成に失敗する" do
      expect(user).not_to be_valid
    end
  end

  context "ユーザー名の入力がない" do
    let(:user) { build(:user, name: nil) }
    it "ユーザーの作成に失敗する" do
      expect(user).not_to be_valid
    end
  end

  context "emailの入力がない" do
    let(:user) { build(:user, email: nil) }
    it "ユーザーの作成に失敗する" do
      expect(user).not_to be_valid
    end
  end

  context "passwordの入力がない" do
    let(:user) { build(:user, password: nil) }
    it "ユーザーの作成に失敗する" do
      expect(user).not_to be_valid
    end
  end
end
