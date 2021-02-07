Rails.application.routes.draw do
  devise_for :admins

  root to: 'books#index'
  resources :books, only: %i[show new create edit update]
end
