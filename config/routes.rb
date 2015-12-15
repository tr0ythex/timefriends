Rails.application.routes.draw do
  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :users, only: [:create]
      post 'login', to: 'sessions#create', as: 'login'
    end
  end
end