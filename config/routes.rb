SocialEvent::Application.routes.draw do
  resources :apps, :only => :index do
    member do
      get :auth
      get :callback
    end
  end

  resources :posts, :only => :index
end
