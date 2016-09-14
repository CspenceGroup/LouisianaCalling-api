Rails.application.routes.draw do

  get 'admin' => 'admin#index', :as => :admin
  post 'upload' => 'admin#upload'
  # resource :admin, only: [:index, :new, :create, :destroy]

  root 'home#index'

  get 'profile' => 'profile#index', :as => :profile
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
