Rails.application.routes.draw do
  devise_for :users
  resources :articles
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root 'articles#index'
end
