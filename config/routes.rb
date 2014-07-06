SocialEvent::Application.routes.draw do
  resources :apps, :only => :index do
    collection do
      get :auth
      get :callback
    end
  end

  resources :posts, :only => :index
end
