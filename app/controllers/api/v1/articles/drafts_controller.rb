module Api::V1
  class Articles::DraftsController < BaseApiController
    before_action :authenticate_user!

    def index
      articles = current_user.articles.draft.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      articles = current_user.articles.draft.find(params[:id])
      render json: articles
    end
  end
end
