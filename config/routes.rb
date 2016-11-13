# frozen_string_literal:true
Rails.application.routes.draw do
  api_version(module: 'V1', path: { value: 'v1' }) do
    post '/users',                to: 'users#create'
    put  '/users/confirm/:token', to: 'users#confirm'

    post '/friends/add',            to: 'friends#add'
    post '/friends/invite',         to: 'friends#invite'
    put  '/friends/confirm/:token', to: 'friends#confirm'
  end
end
