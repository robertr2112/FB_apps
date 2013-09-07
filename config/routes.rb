FBApps::Application.routes.draw do
  get "password_resets/new"
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets

  root  'static_pages#home'
  match '/signup',          to: 'users#new',                    via: 'get'
  match '/signin',          to: 'sessions#new',                 via: 'get'
  match '/signout',         to: 'sessions#destroy',             via: 'delete'
  match '/help',            to: 'static_pages#help',            via: 'get'
  match '/about',           to: 'static_pages#about',           via: 'get'
  match '/contact',         to: 'static_pages#contact',         via: 'get'
  match 'pools/join/:id',   to: 'pools#join',    as: :join,     via: 'get'
  match 'pools/leave/:id',  to: 'pools#leave',   as: :leave,    via: 'get'
  match 'pools/my_pools',   to: 'pools#my_pools',as: :my_pools, via: 'get'
  match 'users/confirm/:confirmation_token',
                            to: 'users#confirm', as: :confirm,  via: 'get'
  match 'users/resend_confirm/:id',  to: 'users#resend_confirm', 
                       as: :resend_confirm,     via: 'get'

  resources :pools do
    resources :weeks, only: [:new, :create]
  end

  resources :weeks, only: [:edit, :update, :show, :destroy] do
    resources :picks, only: [:new, :create]
  end

  resources :picks, only: [:edit, :update, :destroy]

end
