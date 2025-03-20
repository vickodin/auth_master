AuthMaster::Engine.routes.draw do
  get   "/:target/login", to: "sessions#new", as: :auth_master_login
  post  "/:target/login", to: "sessions#send_link"

  get   "/:target/sent",  to: "sessions#sent", as: :auth_master_sent

  get   "/:target/link",  to: "sessions#link", as: :auth_master_link
  post  "/:target/link",  to: "sessions#create"

  get   "/:target/denied", to: "sessions#denied", as: :auth_master_denied
end
