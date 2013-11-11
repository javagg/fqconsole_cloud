Rails.application.routes.draw do
  devise_for :account, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :passwords => "password" }

  # Those will override the same routes in openshift_console
  devise_scope :account do
    root :to => 'site#index'
    get :account, to: 'site#account'
  end

  id_regex = /[^\/]+/

  match "/search" => ApplicationController.action(:search), :anchor => false

  match "/ide" => IdeProxy.new, :anchor => false

  scope :path => "/app" do
    resources :applications, :singular_resource => true do
      resource :ide_restart, :only => [:show, :update], :id => id_regex
      match "/editing" => IdeProxy.new, :anchor => false
    end
    openshift_console
  end
end