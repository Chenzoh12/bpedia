Rails.application.routes.draw do
  resources :wikis
  resources :charges, only: [:new, :create]
  devise_for :users
  post 'charges/downgrade', :to => 'charges#downgrade'
  
  get 'welcome/about'
  root 'welcome#index'
    
end