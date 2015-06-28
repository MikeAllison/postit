PostitTemplate::Application.routes.draw do

  root to: 'posts#index'

  get 'register', to: 'users#new'

  get   'login',  to: 'sessions#new'
  post  'login',  to: 'sessions#create'
  get   'logout', to: 'sessions#destroy'

  # Sets vote_post_path and vote_comment_path (could also use 'member')
  post 'posts/:id/vote',        to: 'posts#vote',         as: 'vote_post'
  post 'comments/:id/vote',     to: 'comments#vote',      as: 'vote_comment'

  post 'users/:id/update_role', to: 'users#update_role',  as: 'update_role'

  post 'posts/:id/flag',        to: 'posts#flag',         as: 'flag_post'
  post 'comments/:id/flag',     to: 'comments#flag',      as: 'flag_comment'

  namespace :admin do
    resources :flags, only: [:index]
  end

  resources :posts, except: [:destroy] do
    resources :comments, only: [:create]
  end

  resources :categories, except: [:destroy]
  resources :users, except: [:index, :destroy]

end
