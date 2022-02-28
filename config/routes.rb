Rails.application.routes.draw do
  # resources :users, only: %i[show update]
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :articles, only: %i[index new create] do
    resources :comments, only: %i[new create update destroy]
  end
  namespace :my do
    resources :users, only: %i[show update destroy]
  end
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'articles#index'
end
