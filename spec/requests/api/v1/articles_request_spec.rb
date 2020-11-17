# require 'rails_helper'

# RSpec.describe "Articles", type: :request do

#   describe "GET /index" do
#     it "returns http success" do
#       get "/articles/index"
#       expect(response).to have_http_status(:success)
#     end
#   end

# end

require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article) }

    it "記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path (article_id) ) }
    context "指定したidの記事が存在するとき" do

      let(:article_id){article.id}
      let(:article){create(:article)}

      it "その記事の詳細を表示できる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]
      end
    end

  context "指定したidの記事が存在しないとき" do
    let(:article_id){100000}
    it "記事が見つからない" do

      expect{subject}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params ) }
    context "適切なパラメーターを送信したとき" do
      let(:params) { { article: attributes_for(:article)} }
      let(:current_user) { create(:user) }
      before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

      it "ユーザーの記事を作成できる" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
