Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
root to: 'main_page#start'
get '/search', to: 'main_page#search'
end
