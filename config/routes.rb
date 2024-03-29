Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'pages#top'
  get 'terms', to: 'pages#terms'
  get 'policy', to: 'pages#policy'
  get 'contact', to: 'pages#contact'

  resources :greetings, only: %i[index show] do
    resources :results, only: %i[show create destroy], shallow: true
  end

  resources :users, only: %i[new edit create update] do
    resources :results, only: %i[index]
  end

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  get 'ranks', to: 'ranks#index'

  namespace :admin do
    root 'dashboards#index'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'
    resources :users, only: %i[index show edit update destroy]
    resources :results, only: %i[index destroy]
  end
end
