PostitTemplate::Application.routes.draw do

  root to: 'posts#index'

  get 'register', to: 'users#new'

  get   'login',  to: 'sessions#new'
  post  'login',  to: 'sessions#create'
  get   'logout', to: 'sessions#destroy'

  namespace :admin do
    resources :flags, only: [:index]
  end

  resources :categories, except: [:destroy]

  resources :users, except: [:index, :destroy] do
    member do
      post 'update_role'
    end
  end

  resources :posts, except: [:destroy] do
    member do
      post 'vote'
      post 'flag'
      post 'clear_flags'
      post 'hide'
    end
    resources :comments, only: [:create]
  end

  # This cannot be nested above under 'resources :comments'
  # Posts and Comments share helper methods for these actions so the paths need to be 'vote_post_path' and 'vote_comment_path'
  # Nesting it above creates 'vote_post_comment_path' - which doesn't work.
  resources :comments do
    member do
      post 'vote'
      post 'flag'
      post 'clear_flags'
      post 'hide'
    end
  end

end
