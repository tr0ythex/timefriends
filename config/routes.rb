Rails.application.routes.draw do
  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :users, only: [:create, :show] do
        get 'posts(/:date)', to: 'posts#index'
      end
      resource :users, only: [:update, :create] do
        resources :posts, only: [:create]
      end
      post 'login', to: 'sessions#create', as: 'login'
      delete 'logout', to: 'sessions#destroy', as: 'logout'
      get 'users(/:limit)(/:offset)', to: 'users#index'
      post 'send_friendship_offer', to: 'users#send_friendship_offer'
      post 'decline_friendship_offer', to: 'users#decline_friendship_offer'
      get 'accept_friendship_offer_from/:login', to: 'users#accept_friendship_offer'
      get 'friendship_offers', to: 'users#friendship_offers'
      get 'friends', to: 'users#friends'
    end
  end
end