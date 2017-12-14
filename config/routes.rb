Rails.application.routes.draw do
  
  resources :wikis
  resources :charges, only: [:new, :create]
  post 'charges/downgrade', :to => 'charges#downgrade'
  devise_for :users
  get 'welcome/about'
  root 'welcome#index'
    
end