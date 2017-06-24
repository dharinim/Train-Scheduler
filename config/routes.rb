Rails.application.routes.draw do
  get 'schedules', to: "schedules#index"
  get 'schedules/trains'

  get '/', to: "homepage#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
