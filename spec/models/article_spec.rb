# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  context "タイトルと記事が入力されている" do
    let(:article){build(:article)}
    it "記事が作成される" do
      expect(article).to be_valid
    end
  end

  context "タイトルが入力されていない" do
    let(:article){build(:article, title: nil)}
    it "記事の作成に失敗" do
      expect(article).not_to be_valid
    end
  end

  context "statusがdraftのとき"do
    let(:article){build(:article, :draft)}
    fit "記事が下書きで作成される" do
      expect(article).to be_valid
      expect(article.status).to eq "draft"
    end
  end

  context "statusがpublishedのとき"do
  let(:article){build(:article, :published)}
    it "記事が公開で作成される" do
      expect(article).to be_valid
      expect(article.status).to eq "published"
    end
  end

end
