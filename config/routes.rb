Rails.application.routes.draw do

  get 'admin' => 'admin#index', :as => :admin
  post 'upload' => 'admin#upload'
  # resource :admin, only: [:index, :new, :create, :destroy]

  root 'home#index'

  get 'profile' => 'profile#index', :as => :profile
  get 'profile/get-more' => 'profile#getMore'


  # career page
  get 'careers' => 'career#index', :as => :career
  get 'career/filter/' => 'career#filter', :as => :career_filter
  get 'careers/:slug' => 'career#detail', :as => :career_detail


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
