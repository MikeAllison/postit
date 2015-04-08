PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get 'register', to: 'users#new'

  get 'login',  to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'

  resource :sessions, only: [:new, :create, :destroy]

  resources :posts, except: [:destroy] do
    resources :comments, only: [:create]
  end

  resources :categories, except: [:destroy]
  resources :users, only: [:new, :create, :show]

end
