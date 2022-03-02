Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'top#index'

  resources :greetings, only: %i[index show] do
    resources :results, only: %i[show create], shallow: true
  end
  get 'ranks', to: 'ranks#index'
end
