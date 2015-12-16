Rails.application.routes.draw do
  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :users, only: :create
      resource :users, only: :update
      post 'login', to: 'sessions#create', as: 'login'
      delete 'logout', to: 'sessions#destroy', as: 'logout'
    end
  end
end