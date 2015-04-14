PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get 'register', to: 'users#new'

  get 'login',  to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'

  resource :sessions, only: [:new, :create, :destroy]

  resources :posts, except: [:destroy] do
    resources :votes, only: [:create]
    resources :comments, only: [:create] do
      resources :votes, only: [:create]
    end
  end

  resources :categories, except: [:destroy]
  resources :users, except: [:index, :destroy]


end
