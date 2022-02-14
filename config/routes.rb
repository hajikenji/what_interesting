Rails.application.routes.draw do
  # resources :users, only: %i[show update]
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :articles, except: %i[update destroy] do
    resources :comments, except: :index
  end
  namespace :my do
    resources :users, only: %i[show update]
  end
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'articles#index'
end
