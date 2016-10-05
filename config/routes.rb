Rails.application.routes.draw do

  get 'errors/not_found'

  get 'errors/internal_server_error'

  get 'admin' => 'admin#index', :as => :admin
  post 'upload' => 'admin#upload'
  # resource :admin, only: [:index, :new, :create, :destroy]

  root 'home#index'

  get 'stories' => 'profile#index', :as => :stories
  get 'profiles/get-more' => 'profile#getMore'
  get 'profiles/:slug' => 'profile#detail', :as => :profile_detail

  # career page
  get 'careers' => 'career#index', :as => :career
  get 'career/filter/' => 'career#filter', :as => :career_filter
  get 'careers/:slug' => 'career#detail', :as => :career_detail

  # education page
  get 'programs' => 'education#index', :as => :education
  get 'programs/:slug' => 'education#detail', :as => :education_detail
  get 'education/filter/' => 'education#filter', :as => :education_filter
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Private policy page
  get 'policy' => 'policy#index', :as => :policy

  # error pages
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  # Contact Us page
  get 'contacts/new' => 'contact#new', :as => :contact
  post 'contacts/create' => 'contact#create', :as => :create_contact
end
