require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    context "自分で作成した下書き記事が存在するとき" do
      let(:headers) { current_user.create_new_auth_token }
      let(:current_user) { create(:user) }
      let!(:article1) { create(:article, :draft, updated_at: 1.days.ago, user: current_user) }
      let!(:article2) { create(:article, :draft, updated_at: 2.days.ago, user: current_user) }
      let!(:article3) { create(:article, :draft, user: current_user) }
      let!(:article4) { create(:article, :draft) }

      it "下書き記事の一覧が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res.length).to eq 3
        expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
        expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      end
    end

    describe "GET api/v1/articles/drafts/:id" do
      subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

      context "指定したidの下書き記事が存在するとき" do
        let(:headers) { current_user.create_new_auth_token }
        let(:current_user) { create(:user) }
        let(:article_id) { article.id }
        let!(:article) { create(:article, :draft, user: current_user) }

        it "その記事の詳細を表示できる" do
          subject
          res = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["updated_at"]).to be_present
          expect(res["user_id"]).to eq article.user.id
          expect(res["status"]).to eq "draft"
        end
      end
    end
  end
end
