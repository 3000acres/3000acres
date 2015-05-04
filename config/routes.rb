Acres::Application.routes.draw do

  resources :posts, :only => [:create, :show]

  resources :local_government_areas

  resources :sites

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  resources :watches

  get '/admin', :to => "admin#index", :as => 'admin'

  get 'events', to: 'events#index'

  comfy_route :cms_admin, :path => '/cms-admin'
  comfy_route :cms, :path => '/', :sitemap => false


end
