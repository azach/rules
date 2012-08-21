Dummy::Application.routes.draw do
  root :to => 'orders#show'

  resources :orders
end
