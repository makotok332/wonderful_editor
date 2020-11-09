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
  end
end
