Rails.application.routes.draw do
  resources :wikis do
      resources :collaborators, only: [:new, :create, :destroy]
  end
  
  resources :charges, only: [:new, :create]
  
  post 'charges/downgrade', :to => 'charges#downgrade'
  
  devise_for :users
  
  post 'charges/downgrade', :to => 'charges#downgrade'
  
  get 'welcome/about'
  
  root 'welcome#index'
    
end