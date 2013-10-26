Acres::Application.routes.draw do

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  ComfortableMexicanSofa::Routing.admin(:path => '/cms-admin')
  ComfortableMexicanSofa::Routing.content(:path => '/', :sitemap => false)
end
