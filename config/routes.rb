Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    resources :products
    get "demo_partials/new"
    get "demo_partials/edit"

    get "static_pages/home"
    get "static_pages/help"

    get "signup", to:"users#new"
    post "signup", to: "users#create"
    resources :users, except: %i(new create)

    resources :users do
      member do
        get :following, :followers
      end
    end

    get 'login', to:"sessions#new"
    post 'login', to:"sessions#create"
    get 'logout', to:"sessions#destroy"

    resources :account_activations, only: %i(edit)

    resources :password_resets, except: %i(destroy index show)

    resources :microposts, only: %i(create destroy)

    resources :relationships, only: %i(create destroy)
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
