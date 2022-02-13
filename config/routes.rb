Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'top#index'

  resources :greetings, only: %i[index show]
  post 'analyse', to: 'results#analyse'
  get 'result', to: 'results#show'
  post 'result', to: 'results#show'
end
