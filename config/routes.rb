Rails.application.routes.draw do

  get 'errors/not_found'

  get 'errors/internal_server_error'

  get 'admin' => 'admin#index', :as => :admin
  post 'upload' => 'admin#upload'
  # resource :admin, only: [:index, :new, :create, :destroy]

  root 'home#index'

  get 'stories' => 'profile#index', :as => :stories
  get 'profiles/get-more' => 'profile#get_more'
  get 'profiles/:slug' => 'profile#detail', :as => :profile_detail

  # career page
  get 'careers' => 'career#index', :as => :career
  get 'career/filter' => 'career#filter', :as => :career_filter
  get 'careers/:slug' => 'career#detail', :as => :career_detail
  get 'guided_journey/search' => 'guided_journey#search', :as => :guided_journey_search

  # education page
  get 'education' => 'education#index', :as => :education
  get 'education/filter' => 'education#filter', :as => :education_filter
  get 'education/:slug' => 'education#detail', :as => :education_detail
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Private policy page
  get 'policy' => 'policy#index', :as => :policy

  # error pages
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  # About Us page
  get 'abouts' => 'about#index'
  post 'abouts' => 'about#create'

  # Guided Journey page
  get 'guided-journey' => 'guided_journey#index'
end
