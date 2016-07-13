Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  get     'containers',               :to => 'containers#index',  :as => 'containers_index'
  get     'containers/:id/show',      :to => 'containers#show',   :as => 'containers_show',      :constraints => { :id => /[^\#]+/ }
  get     'containers/index'
  get     'containers/new',           :to => 'containers#new',    :as => 'containers_new'
  post    'containers/new'
  get     'containers/new/:id/setup', :to => 'containers#setup',  :as => 'containers_setup'
  post    'containers/:id/start',     :to => 'containers#start',  :as => 'containers_start'
  post    'containers/:id/stop',      :to => 'containers#stop',   :as => 'containers_stop'
  post    'containers/:id/kill',      :to => 'containers#kill',   :as => 'containers_kill'
  delete  'containers/:id/delete',    :to => 'containers#delete', :as => 'containers_delete'
  post    'containers/:id/create',    :to => 'containers#create', :as => 'containers_create',    :constraints => { :id => /[^\#]+/ }

  get     'images',                   :to => 'images#index',      :as => 'images_index'
  get     'images/index'
  get     'images/new'
  get     'images/show/:id',          :to => 'images#show',       :as => 'images_show',         :constraints => { :id => /[^\#]+/ }
  delete  'images/:id/delete',        :to => 'images#delete',     :as => 'images_delete',       :constraints => { :id => /[^\#]+/ }
  post    'images/:id/create',        :to => 'images#create',     :as => 'images_create',       :constraints => { :id => /[^\#]+/ }

  get     'dockerfiles',                :to => 'dockerfiles#index', :as => 'dockerfiles_index'
  get     'dockerfiles/index'
  get     'dockerfiles/create',         :to => 'dockerfiles#new',    :as => 'dockerfiles_new'
  post    'dockerfiles/create',         :to => 'dockerfiles#create', :as => 'dockerfiles_create'
  get     'dockerfiles/:file/edit',     :to => 'dockerfiles#edit',   :as => 'dockerfiles_edit',   :constraints => { :file => /[^\#]+/ }
  put     'dockerfiles/:file/save',     :to => 'dockerfiles#save',   :as => 'dockerfiles_save',   :constraints => { :file => /[^\#]+/ }
  delete  'dockerfiles/:file/delete',   :to => 'dockerfiles#delete', :as => 'dockerfiles_delete', :constraints => { :file => /[^\#]+/ }
end
