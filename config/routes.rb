Rails.application.routes.draw do
  scope :path => "/app" do
    openshift_console
  end
  #root :to => 'site#index'
end
