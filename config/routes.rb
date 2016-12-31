Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'top/index', to: 'top#index'
  post 'top/index', to: 'top#index'
  get 'top/index'
  post 'top/index'
end
