Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#index"
    resources :products
    get "demo_partials/new"
    get "demo_partials/edit"
    get "static_pages/home"
    get "static_pages/help"
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
