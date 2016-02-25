Rails.application.routes.draw do
  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :users, only: [:create, :show] do
        get 'posts(/:date)', to: 'posts#index'
        get 'post_days(/:year)(/:month)', to: 'posts#post_days'
        # resources :posts, only: [:index]
      end
      
      resource :users, only: [:update, :create] do
        resources :posts, only: [:create, :update, :destroy]
        get 'posts(/:feed)(/:date)', to: 'posts#feed'
        get 'post_days(/:year)(/:month)', to: 'posts#post_days'
        get 'bg_packs(/:name)(/:device_type)', to: 'bg_packs#index'
      end
      
      post 'posts/:post_id/comments', to: "comments#create"
      
      post 'login', to: 'sessions#create', as: 'login'
      delete 'logout', to: 'sessions#destroy', as: 'logout'
      get 'users(/:limit)(/:offset)', to: 'users#index'
      
      post 'send_friendship_offer', to: 'users#send_friendship_offer'
      post 'decline_friendship_offer', to: 'users#decline_friendship_offer'
      post 'accept_friendship_offer', to: 'users#accept_friendship_offer'
      post 'remove_friend', to: 'users#remove_friend'
      
      get 'requested_friends', to: 'users#requested_friends'
      get 'pending_friends', to: 'users#pending_friends'
      get 'friends', to: 'users#friends'
      get 'friends_with/:login', to: 'users#friends_with'
      
      post 'posts/join', to: 'posts#join'
      post 'posts/leave', to: 'posts#leave'
    end
  end
end