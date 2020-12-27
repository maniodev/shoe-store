# frozen_string_literal: true
require "sidekiq/web"
Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
  post "/graphql", to: "graphql#execute"
  root to: "admin/dashboard#index"
  mount Sidekiq::Web => "/admin/sidekiq"

  namespace :admin do
    get "dashboard/index"
    post "dashboard/refresh"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount ActionCable.server => "/cable"

  namespace :api do
    namespace :v1 do
      resources :inventories, only: %i[index]
    end
  end
end
