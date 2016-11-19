# frozen_string_literal:true
Rails.application.routes.draw do
  api_version(module: 'V1', path: { value: 'v1' }) do
    post '/users',                  to: 'users#create'
    put  '/users/confirm',          to: 'users#confirm'
    get  '/users',                  to: 'users#show'

    get  '/friends',                to: 'friends#show'
    post '/friends/invite',         to: 'friends#invite'
    put  '/friends/confirm/:token', to: 'friends#confirm'

    post '/alerts',                 to: 'alerts#create'

    post '/sessions',               to: 'sessions#create'
  end
end
