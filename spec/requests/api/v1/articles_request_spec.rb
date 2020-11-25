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

  describe "POST /article" do
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

  describe "PATCH(PUT) /article/:id" do
    subject { patch(api_v1_article_path(article_id), params: params ) }
      let(:article_id){article.id}
      let(:params) { { article: attributes_for(:article)} }
      let(:current_user) { create(:user) }
      before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
    context "ユーザーの既存の記事を更新するとき" do
        let(:article){create(:article, user: current_user)}
      it "ユーザーの記事を更新できる" do
        expect {subject}.to change {Article.find(article_id).title}.from(article.title).to(params[:article][:title]) &
                            change {Article.find(article_id).body}.from(article.body).to(params[:article][:body])
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログインしていないユーザーが記事の更新をしようとするとき" do
      let(:other_user) { create(:user) }
      let(:article){create(:article, user: other_user)}
      it "記事の更新に失敗する" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE /article/:id" do
    subject { delete(api_v1_article_path(article_id)) }
      let(:article_id){article.id}
      let(:current_user) { create(:user) }
    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
    context "ユーザーの既存の記事を削除するとき" do
      let!(:article){create(:article, user: current_user)}
      it "ユーザーの記事を削除できる"do
    expect { subject }.to change { Article.count }.by(-1)
    expect (response).to have_http_status(:no_content)
      end
    end
    context "ログインしていないユーザーが記事を削除しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article){create(:article, user: other_user)}
      it "記事の削除に失敗する" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
        
      end
    end

  end

end
