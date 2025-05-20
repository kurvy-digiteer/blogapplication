Rails.application.routes.draw do
  # METHOD NAME: get, post, delete, patch, put, etc. "URLNAME", or"folder/file" or "folder#file", or "folder/file#action", or
  # "folder", to: "controller#action" or to: "folder#action", as: :name.
  # This name will be read as (LIST OF SUFFIXES: namespace, edit, create, update, destroy, etc.) suffix_name_path
  get "featured", to: "featured#index", as: :featured_index
  # Read as featured_path if you wanna access the index page of the /featured folder
  resources :featured, only: [ :new, :create, :edit, :update, :show, :destroy ], path: "featured" do
    resources :comments, only: [ :create, :update, :destroy ], module: nil
  end
    # authenticated :user, ->(user) { user.admin? } do
    # Admin authentication routes WIP


    # Admin dashboard routes

    namespace :admin do
      # This sets the root path for the admin section
      # When someone visits /admin, they'll see the admin dashboard
      root to: "admin#index"

      # Use proper RESTful routing for posts
      resources :posts, only: [ :index, :show, :edit, :update, :destroy ]

      # This creates routes for users with specific actions
      # GET /admin/users - Lists all users
      # GET /admin/users/1/edit - Shows edit form for user 1
      # PATCH/PUT /admin/users/1 - Updates user 1
      # DELETE /admin/users/1 - Deletes user 1
      # Creates helpers: admin_users_path, edit_admin_user_path, admin_user_path
      resources :users, only: [ :index, :edit, :update, :destroy ]

      resources :customers, only: [ :index, :edit, :update, :destroy ]

      # This creates routes for comments with specific actions
      # GET /admin/comments - Lists all comments
      # GET /admin/comments/1/edit - Shows edit form for comment 1
      # PATCH /admin/comments/1 - Updates comment 1
      # DELETE /admin/comments/1 - Deletes comment 1
      # Creates helpers: admin_comments_path, edit_admin_comment_path, admin_comment_path
      resources :comments, only: [ :index, :edit, :update, :destroy ]
    end


  # FOLLOW THIS FORMAT IF YOU WANT TO ADD MORE ROUTES TO THE ADMIN SECTION WITH
  # SPECIFIC ACTIONS FOR A RESOURCE, LIKE THE USERS RESOURCE ABOVE, if you want to
  # add more routes for the users resource THAT ARE NOT IN THE RESTFUL ROUTES (this is very useful btw),
  # you can do it like this:
  # resources :users do
  #   member do
  #     # GET /admin/users/1/edit - Shows edit form for user 1
  #     # Creates helper: edit_admin_user_path(user)
  #     get :edit

  # PATCH /admin/users/1 - Updates user 1 i dont think this is needed but just in case
  # Creates helper: admin_user_path(user)
  # patch :update

  # PUT /admin/users/1 - Updates user 1
  # Creates helper: admin_user_path(user)
  # put :update

  # DELETE /admin/users/1 - Deletes user 1
  # Creates helper: admin_user_path(user)
  # delete :destroy
  # # post :dowhatever_command_here
  # end
  # end

  get "search", to: "search#index"
  get "users/profile"
  get "customers/profile"

  # Custom Devise routes for user login, signup, edit, and delete specifically
  devise_for :users, path: "admin", path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "register",
    edit: "edit"
  }, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_for :customers, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "register",
    edit: "edit"
  }, controllers: {
    sessions: "customers/sessions",
    registrations: "customers/registrations"
  }


  get "u/:id", to: "users#profile", as: "user"
  get "c/:id", to: "customers#profile", as: "customer"

  # /posts/1/comments/4
  resources :posts do
    resources :comments
    resources :likes, only: [ :create, :destroy ]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
end
