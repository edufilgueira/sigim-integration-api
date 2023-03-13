Rails.application.routes.draw do
  devise_for :users
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  
  root to: 'site/welcome#index'
  get 'site', to: 'site/welcome#index'
  
  namespace :api do
    get 'oisol/vitimas',      to: 'oisol#vitimas'
    get 'oisol/etl_imports',  to: 'oisol#etl_imports'
    get 'nudem/instrumental', to: 'nudem#instrumental'
    get 'nudem/etl_imports',  to: 'nudem#etl_imports'
  end
  
  namespace :site do
    get 'welcome/index'
    get 'welcome/index', to: 'welcome#index'
    resources :system_occurrences do
      collection do
        get '/ignored',       to: 'system_occurrences#ignored'
        get '/inconsistency', to: 'system_occurrences#inconsistency'
        get '/agruped',       to: 'system_occurrences#agruped'
        get '/authorize',     to: 'system_occurrences#authorize'
        get '/neighborhood_by_city', to: 'system_occurrences#neighborhood_by_city'
        get '/total_errors',  to: 'system_occurrences#total_errors'
      end
    end
  end
  
end