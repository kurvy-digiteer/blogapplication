Rails.application.routes.draw do
  authenticated :user, ->(user) { user.admin? } do
    # Admin authentication routes WIP
    devise_scope :user do
      get "admin/login", to: "admin/sessions#new", as: :admin_login
      post "admin/login", to: "admin/sessions#create"
      delete "admin/logout", to: "admin/sessions#destroy", as: :admin_logout
    end

    # Admin dashboard routes
    get "admin", to: "admin#index"
    get "admin/posts"
    get "admin/comments"
    get "admin/users"
    get "admin/show_post/:id", to: "admin#show_post", as: :admin_post
    delete "admin/destroy_post/:id", to: "admin#destroy_post", as: :admin_destroy_post
  end

  get "search", to: "search#index"
  get "users/profile"

  # Custom Devise routes for user login, signup, edit, and delete specifically
  devise_scope :user do
    get "login", to: "users/sessions#new", as: :user_login
    post "login", to: "users/sessions#create"
    delete "logout", to: "users/sessions#destroy", as: :user_logout
    get "sign_up", to: "users/registrations#new", as: :user_signup
    post "sign_up", to: "users/registrations#create"
    get "edit", to: "users/registrations#edit", as: :edit_user
    put "edit", to: "users/registrations#update"
    patch "edit", to: "users/registrations#update"
    delete "", to: "users/registrations#destroy", as: :delete_user
  end

  # Default devise routes as said by devise documentation, do not remove just in case
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }, skip: [ :sessions, :registrations ]

  get "u/:id", to: "users#profile", as: "user"

  # /posts/1/comments/4
  resources :posts do
    resources :comments
  end

  get "about", to: "pages#about"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
end
