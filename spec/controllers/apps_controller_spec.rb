require 'spec_helper'

describe AppsController do

  describe "#index" do
    it "should assign the supported apps to an array" do
      get :index
      assigns(:apps).should eq [:instagram]
    end
  end

  describe "#auth" do
    it "should redirect to Instagram authorization" do
      get :auth
      response.should redirect_to "https://api.instagram.com/oauth/authorize/?client_id=9c4cbd25a10e4d75a5652615853542a3&redirect_uri=http%3A%2F%2Fwww.social_event.dev%2Fapps%2Fcallback&response_type=code"
    end
  end

  describe "#callback" do
    let(:user) { Hashie::Mash.new(:id => 1) }
    before do
      Instagram.should_receive(:get_access_token)
        .with("auth_code", :redirect_uri => IG_CALLBACK_URL)
        .and_return(Hashie::Mash.new({
          :access_token => 'ig_access_token',
          :user => {
            :full_name => 'Ryan Norman',
            :id => '1',
            :profile_picture => "http://instagram.com/profile.jpg",
            :username => "ryan_norman"
          }
        }))
    end

    it "should save the access token and profile details in newly created user" do
      User.should_receive(:create).with({
        :service_id => '1',
        :service_type => "Instagram",
        :name => 'Ryan Norman',
        :username => "ryan_norman",
        :access_token => 'ig_access_token',
        :profile_image_url => "http://instagram.com/profile.jpg"
      }).and_return(user)

      get :callback, :code => "auth_code"
      assigns(:user).should eq user
    end
  end
end
