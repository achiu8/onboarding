Rails.application.routes.draw do
  get 'users' => 'users#index'
  get 'users/:username' => 'users#show'
  get 'users/:username/:reponame' => 'repos#show'
  get 'repos/new' => 'repos#new'
  post 'repos' => 'repos#create'
  post 'repos/submit' => 'repos#submit'
end
