FBApps::Application.routes.draw do
  get "password_resets/new"
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets

  root  'static_pages#home'
  match '/signup',            to: 'users#new',                    via: 'get'
  match '/signin',            to: 'sessions#new',                 via: 'get'
  match '/signout',           to: 'sessions#destroy',             via: 'delete'
  match '/help',              to: 'static_pages#help',            via: 'get'
  match '/about',             to: 'static_pages#about',           via: 'get'
  match '/contact',           to: 'static_pages#contact',         via: 'get'
  match 'pools/join/:id',     to: 'pools#join',    as: :join,     via: 'get'
  match 'pools/leave/:id',    to: 'pools#leave',   as: :leave,    via: 'get'
  match 'pools/my_pools',     to: 'pools#my_pools',as: :my_pools, via: 'get'
  match 'weeks/open/:id',     to: 'weeks#open',    as: :open,     via: 'get'
  match 'weeks/closed/:id',   to: 'weeks#closed',  as: :closed,   via: 'get'
  match 'weeks/final/:id',    to: 'weeks#final',   as: :final,    via: 'get'
  match 'seasons/open/:id',   to: 'seasons#open',    as: :season_open,   via: 'get'
  match 'seasons/closed/:id', to: 'seasons#closed',  as: :season_closed, via: 'get'
  match 'users/confirm/:confirmation_token', to: 'users#confirm', 
                       as: :confirm,  via: 'get'
  match 'users/resend_confirm/:id',  to: 'users#resend_confirm', 
                       as: :resend_confirm,     via: 'get'
  match 'users/admin_add/:id', to: 'users#admin_add',    
                       as: :admin_add,     via: 'get'
  match 'users/admin_del/:id', to: 'users#admin_del',    
                       as: :admin_del,     via: 'get'


  resources :seasons, shallow: :true do
    resources :weeks
  end
  
  resources :pools do
    resources :entries, only: [:new, :create]
    resources :pool_messages, only: [:new, :create]
  end
  
  resources :entries, only: [:edit, :update, :destroy] do
    resources :picks, only: [:new, :create]
  end

  resources :weeks, only: [:edit, :update, :show, :destroy]

  resources :picks, only: [:edit, :update, :destroy]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
