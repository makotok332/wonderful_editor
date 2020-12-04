require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "適切なパラメーターを送信したとき" do
      let(:params) { { user: attributes_for(:user) } }

      it "ユーザーの新規登録できる" do
        aggregate_failures "最後まで通過" do
          expect { subject }.to change { User.count }.by(1)
          expect(response).to have_http_status(:ok)
          res = JSON.parse(response.body)
          expect(res["data"]["name"]).to eq params[:user][:name]
          expect(res["data"]["email"]).to eq params[:user][:email]
        end
      end
    end

    context "nameがないとき" do
      let(:params) { { user: attributes_for(:user, name: nil) } }

      it "エラーする" do
        aggregate_failures "最後まで通過" do
          expect { subject }.to change { User.count }.by(0)
          res = JSON.parse(response.body)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(res["errors"]["name"]).to eq ["can't be blank"]
        end
      end
    end

    context "emailがないとき" do
      let(:params) { { user: attributes_for(:user, email: nil) } }

      it "エラーする" do
        aggregate_failures "最後まで通過" do
          expect { subject }.to change { User.count }.by(0)
          res = JSON.parse(response.body)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(res["errors"]["email"]).to eq ["can't be blank"]
        end
      end
    end

    context "passwordがないとき" do
      let(:params) { { user: attributes_for(:user, password: nil) } }

      it "エラーする" do
        aggregate_failures "最後まで通過" do
          expect { subject }.to change { User.count }.by(0)
          res = JSON.parse(response.body)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(res["errors"]["password"]).to eq ["can't be blank"]
        end
      end
    end
  end
end
