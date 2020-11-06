Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      post '/new' => 'sessions#create_new_user'
      get '/auth_by_email' => 'sessions#auth_by_email'
      get '/auth_by_token' => 'sessions#auth_by_token'
      get '/get_user_by_id' => 'sessions#get_user_by_id'
      resources :posts 
    end
  end

end
