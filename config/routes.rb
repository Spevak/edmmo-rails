EdmmoRails::Application.routes.draw do
  get "map/editor"
  devise_for :users

  root 'welcome#index'
  get 'kinetic_test' => 'welcome#kinetic_test'
  get 'map/editor' => 'map#editor'
  post 'map/load' => 'map#load'
  post 'map/save' => 'map#save'

  namespace :api do
    namespace :test do
      get 'world/tiles' => 'world#tiles'
      # TODO change the route to players/*. Requires collab with interpreter team.
      # do it in v1 too.
      post 'player/move' => 'player#move'
      post 'player/pickup' => 'player#pickup'
      post 'player/drop' => 'player#drop'
      post 'player/use' => 'player#use'
      post 'player/dig' => 'player#dig'
      get 'player/status' => 'player#status'
      post 'player/inspect' => 'player#inspect'
      get 'player/characters' => 'player#characters'
    end
    # TODO lets clean up these naming conventions so they match
    namespace :v1 do
      get 'world/tiles' => 'world#tiles'
      post 'player/move' => 'players#move'
      post 'player/pickup' => 'players#pickup'
      post 'test_session' => 'base#test_session' if Rails.env.development?
      get 'player/status' => 'players#status'
      post 'player/inspect' => 'players#inspect'
      post 'player/drop' => 'players#drop'
      post 'player/dig' => 'players#dig'
      get 'player/characters' => 'players#characters'
      post 'player/use' => 'players#use'
    end
  end


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
