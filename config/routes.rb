Rails.application.routes.draw do
  devise_for :users
  root to: redirect('/dayLog/list')
  resources :memos
   
  post 'dayLog/list', to: 'memos#list', as: 'list'
  get 'dayLog/memos/mark_ready', to: 'memos#mark_ready'

  get 'dayLog/memos/reopen', to: 'memos#reopen'
  get 'dayLog/memos/delete', to: 'memos#delete'
  get 'dayLog/memos/delete_recurrence', to: 'memos#delete_recurrence'

  get '/redirect', to: 'memos#redirect', as: 'redirect'
  get '/callback', to: 'memos#callback', as: 'callback'
  get '/calendars', to: 'memos#calendars', as: 'calendars'
  # post '/events/:calendar_id', to: 'memos#new_event', as: 'new_event', calendar_id: /[^\/]+/
    post '/new_event', to: 'memos#new_event', as: 'new_event', calendar_id: /[^\/]+/

  get 'dayLog/list', to: 'memos#list'
  post 'memos/new', to: 'memos#create'

  get 'memos/new'
  post 'memos/create'
  patch 'memos/update'
  get 'memos/show'
  get 'memos/edit'
  get 'memos/delete'
  get 'memos/delete_recurrence'
  get 'memos/update'
  get 'memos/show_subjects'
  get 'memos/mark_ready'
  get 'memos/reopen'


end
