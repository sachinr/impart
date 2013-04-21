Votes::Application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'

  devise_for :users, :controllers => { :registrations => "registrations",
                                       :invitations => 'users/invitations' }

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
    resources :users
    resources :user_confirmations, only: [:update]
    resources :user_roles, only: [:update]
    resources :site_settings, only: [:index, :edit, :update]
  end

  resources :inbound_emails

  match 'latest' => 'posts#latest', as: 'latest_posts'
  match 'top/:period' => 'posts#top', as: 'top_posts'
  root :to => "posts#index"

end
