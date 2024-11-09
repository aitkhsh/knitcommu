Rails.application.routes.draw do
  root "static_pages#top"

  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"

  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider

  resources :users, only: %i[new create]
  resources :pictures, only: %i[index create] do
    post :select_image, on: :collection # select_imageアクション用のルート
  end
  resources :boards, only: %i[index new create show edit destroy] do
    resources :comments, only: %i[create show edit destroy], shallow: true
    collection do
      get :search
    end
  end
  get "board_sessions/save", to: "board_sessions#save"
  get "board_sessions/clear", to: "board_sessions#clear"
  get "images/ogp.png", to: "images#ogp", as: "images_ogp"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
