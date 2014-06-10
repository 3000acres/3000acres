Acres::Application.routes.draw do

  resources :posts, :only => [:create, :show]

  resources :local_government_areas

  resources :sites

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  resources :watches

  get '/admin', :to => "admin#index", :as => 'admin'

  ComfortableMexicanSofa::Routing.admin(:path => '/cms-admin')
  ComfortableMexicanSofa::Routing.content(:path => '/', :sitemap => false)


end
