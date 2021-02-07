Rails.application.routes.draw do
  devise_for :admins

  root to: 'books#index'
  resources :books, only: [:show]
end
