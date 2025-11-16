Rails.application.routes.draw do
  root "dashboard#index"

  resources :customers, only: [ :index ]

  resources :parse_logs, only: [ :index, :create ]

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
