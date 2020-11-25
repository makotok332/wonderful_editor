# class ArticlesController < ApplicationController
#   def index
#     articles = Article.all
#     render json: articles
#   end
# end

module Api::V1
  class ArticlesController < BaseApiController
    def index
      articles = Article.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      articles = Article.find(params[:id])
      render json: articles
    end

    def create
      article = current_user.articles.create!(article_params)
      render json: article
    end

    def update
      article = current_user.articles.find(params[:id])
      article.update!(article_params)
      render json: article
    end

    def destroy
      article = current_user.articles.find(params[:id])
      article.destroy!
    end

    private

      def article_params
        params.require(:article).permit(:title, :body)
      end
  end
end
