PostitTemplate::Application.routes.draw do

  root to: 'posts#index'

  get 'register', to: 'users#new'

  controller :sessions do
    get   'login'  => :new
    post  'login'  => :create
    get   'logout' => :destroy
  end

  namespace :admin do
    resources :flags, only: [:index]
    resources :categories, except: [:destroy]
  end

  resources :categories, only: [:show]

  resources :users, except: [:index, :destroy] do
    member do
      patch 'update_role'
    end
  end

  resources :posts, except: [:destroy] do
    member do
      post 'vote'
      post 'flag'
      patch 'clear_flags'
      patch 'hide'
    end
    resources :comments, only: [:create], shallow: true do
      member do
        post 'vote'
        post 'flag'
        patch 'clear_flags'
        patch 'hide'
      end
    end
  end

end
