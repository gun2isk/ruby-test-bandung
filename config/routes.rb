Rails.application.routes.draw do
  devise_for :users
  
  root to: 'home#index'

  resources :profiles do
    get :charts, on: :member
    
    resources :backups, only: [:index, :show] do
      post :run, on: :collection
      
      member do
        post :download_file
        get :file_history
        post :restore_file
        delete :destroy_file
      end
    end
  end
end
