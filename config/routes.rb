Rails.application.routes.draw do

  get 'admin' => 'admin#index', :as => :admin
  post 'upload' => 'admin#upload'
  # resource :admin, only: [:index, :new, :create, :destroy]

  root 'home#index'

  get 'stories' => 'profile#index', :as => :stories
  get 'profile/get-more' => 'profile#getMore'


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
end
