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
    resources :comments, only: [:create], shallow: true do
      member do
        post 'vote'
        post 'flag'
        post 'clear_flags'
        post 'hide'
      end
    end
  end

end
