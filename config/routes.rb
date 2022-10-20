Rails.application.routes.draw do
  namespace :api do 
    namespace :v1 do
      namespace :items do 
        get '/find', to: 'search#show'
      end
      
      namespace :merchants do
        get 'find_all', to: 'search#show'
      end

      resources :merchants, only: [:index, :show] do 
        resources :items, only: [:index], controller:  'merchants_items'
      end

      resources :items do
        resource :merchant, only: [:show], controller: 'item_merchant'
      end
    end
  end
end
