PostitTemplate::Application.routes.draw do
  root to: 'posts#index'
  
  get 'login',  to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'

  resources :posts, except: [:destroy] do
    resources :comments, only: [:create]
  end

  resources :categories, except: [:destroy]

  resources :sessions, only: [:create, :destroy]

end
