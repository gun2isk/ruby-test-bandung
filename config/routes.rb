Rails.application.routes.draw do
  devise_for :users
  
  root to: 'home#index'

  resources :profiles do
    resources :backups, only: [:index, :show] do
      post :run, on: :collection
      
      member do
        post :download_file
        get :file_history
        delete :destroy_file
      end
    end
  end
end
