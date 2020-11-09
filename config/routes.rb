# frozen_string_literal: true

Rails.application.routes.draw do
  get "articles/index"
  resources :article_previews
  namespace :api do
    namespace :v1 do
      resources :articles
      mount_devise_token_auth_for "User", at: "auth"
    end
  end

  # mount_devise_token_auth_for "User", at: "auth"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
