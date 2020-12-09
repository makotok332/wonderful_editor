RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "適切な登録済みユーザーの情報を送信したとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }
      it "ログインできる" do
        subject
        expect(response).to have_http_status(:ok)
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["uid"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
      end
    end

    context "emailが不適切なとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: "hoge", password: user.password) }
      it "ログインできない" do
        subject
        expect(response).to have_http_status(:unauthorized)
        res = JSON.parse(response.body)
        header = response.header
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["access-token"]).not_to be_present
        expect(header["uid"]).not_to be_present
        expect(header["client"]).not_to be_present
        expect(header["expiry"]).not_to be_present
      end
    end

    context "passwordが不適切なとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: "hoge") }
      it "ログインできない" do
        subject
        expect(response).to have_http_status(:unauthorized)
        res = JSON.parse(response.body)
        header = response.header
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["access-token"]).not_to be_present
        expect(header["uid"]).not_to be_present
        expect(header["client"]).not_to be_present
        expect(header["expiry"]).not_to be_present
      end
    end
  end
end
