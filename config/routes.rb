Rails.application.routes.draw do
  devise_for :users
  
  root to: 'home#index'

  resources :profiles do
    resources :backups, only: [:index, :show] do
      post :run, on: :collection
    end
  end
end
