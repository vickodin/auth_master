Rails.application.routes.draw do
  get   "/:target/login", to: "auth_master/sessions#new", as: :auth_master_login
  # get '/manager/login', to: 'auth_master/sessions#new', as: :auth_login

  mount AuthMaster::Engine, at: "/"
end
