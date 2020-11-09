# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  nickname               :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
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
