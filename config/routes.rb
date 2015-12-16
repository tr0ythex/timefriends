Rails.application.routes.draw do
  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :users, only: :create
      resource :users, only: :update
      post 'login', to: 'sessions#create', as: 'login'
      delete 'logout', to: 'sessions#destroy', as: 'logout'
      get 'users(/:limit)(/:offset)', to: 'users#index'
      get 'send_friendship_offer_to/:login', to: 'users#send_friendship_offer'
      get 'accept_friendship_offer_from/:login', to: 'users#accept_friendship_offer'
      get 'friendship_offers', to: 'users#friendship_offers'
      get 'friends', to: 'users#friends'
    end
  end
end