Rails.application.routes.draw do
  # get, post, delete, patch, put, etc. "URLNAME", or"folder/file" or "folder#file", or "folder/file#action", or
  # "folder", to: "controller#action" or to: "folder#action", as: :name.
  # This name will be read as (namespace or edit, create, update, destroy, etc.)_suffix_name_path
  get "featured", to: "featured#index", as: :featured
  resources :featured, only: [ :new, :create, :edit, :update, :show, :destroy ]
    # authenticated :user, ->(user) { user.admin? } do
    # Admin authentication routes WIP
    devise_scope :user do
      get "admin/login", to: "admin/sessions#new", as: :admin_login
      post "admin/login", to: "admin/sessions#create"
      delete "admin/logout", to: "admin/sessions#destroy", as: :admin_logout
    # end

    # Admin dashboard routes

    namespace :admin do
      # This sets the root path for the admin section
      # When someone visits /admin, they'll see the admin dashboard
      root to: "admin#index"

      # Custom route for showing a post
      # GET /admin/show_post/1 will show post with ID 1
      # The 'as: :post' creates a helper method called 'admin_post_path'
      get "show_post/:id", to: "admin#show_post", as: :post

      # Custom route for deleting a post
      # DELETE /admin/destroy_post/1 will delete post with ID 1
      # The 'as: :destroy_post' creates a helper method called 'admin_destroy_post_path'
      delete "destroy_post/:id", to: "admin#destroy_post", as: :destroy_post

      # This line is VERY IMPORTANT, basta ganun. Ewan haha joke,
      # It tells Rails to use the 'posts' resource for the admin section
      # The 'only: [ :index ]' part means that only the 'index' action will be used
      # The 'index' action is the default action for the 'posts' resource
      # It displays a list of all posts
      # GET /admin/posts will list all posts
      # Creates helper: admin_posts_path
      resources :posts, only: [ :index ]

      # This creates routes for users with specific actions
      # GET /admin/users - Lists all users
      # GET /admin/users/1/edit - Shows edit form for user 1
      # PATCH/PUT /admin/users/1 - Updates user 1
      # DELETE /admin/users/1 - Deletes user 1
      # Creates helpers: admin_users_path, edit_admin_user_path, admin_user_path
      resources :users, only: [ :index, :edit, :update, :destroy ]

      # This creates routes for comments with specific actions
      # GET /admin/comments - Lists all comments
      # GET /admin/comments/1/edit - Shows edit form for comment 1
      # PATCH /admin/comments/1 - Updates comment 1
      # DELETE /admin/comments/1 - Deletes comment 1
      # Creates helpers: admin_comments_path, edit_admin_comment_path, admin_comment_path
      resources :comments, only: [ :index, :edit, :update, :destroy ]
    end
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

  # Default devise routes as said by devise documentation, do not remove just in case even if
  # it wont be used
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
