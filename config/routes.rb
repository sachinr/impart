Votes::Application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'

  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :posts do
    resources :post_votes, only: [:create, :destroy]
    member do
      get :description
    end
  end

  resources :comments, only: [:create, :destroy] do
    resources :comment_votes, only: [:create, :destroy]
  end

  resources :content_fetcher, only: [:index]

  namespace :admin do
    resources :users do
      member do
        post :confirm
      end
    end

  end

  resources :inbound_emails

  match 'latest' => 'posts#latest', as: 'latest_posts'
  match 'top/:period' => 'posts#top', as: 'top_posts'
  root :to => "posts#index"

end
