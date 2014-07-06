class User < ActiveRecord::Base
  attr_accessible :access_token, :name, :profile_image_url, :service_id, :service_type, :username
end
