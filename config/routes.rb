PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get 'register', to: 'users#new'

  get   'login',  to: 'sessions#new'
  post  'login',  to: 'sessions#create'
  get   'logout', to: 'sessions#destroy'

  resources :posts, except: [:destroy] do
    post :vote, on: :member
    resources :comments, only: [:create]
  end

  post 'comments/:id/vote', to: 'comments#vote', as: 'vote_comment'

  resources :categories, except: [:destroy]
  resources :users, except: [:index, :destroy]

end
