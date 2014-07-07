require 'spec_helper'

describe InstagramClient do
  let(:client) { InstagramClient.new }

  describe "#initialize" do
    it "should initalize a user client" do
      pending "Need to initialize a user client"
    end
  end

  describe "#authorize_url" do
    it "should retrieve the instagram callback url" do
      Instagram.should_receive(:authorize_url)
        .with(:redirect_uri => InstagramClient::CALLBACK_URL)
      client.authorize_url
    end
  end

  describe "#get_access_token" do
    it "should get the access token data" do
      Instagram.should_receive(:get_access_token)
        .with('access_code', :redirect_uri => InstagramClient::CALLBACK_URL)
      client.get_access_token('access_code')
    end
  end

  describe "#auth_params" do
    it "should return an array with :code" do
      client.auth_params.should eq [:code]
    end
  end

  describe "#user_params_from_access_token" do
    it "should return params for creating a user from instagram access token" do
      user_params = client.user_params_from_access_token(Hashie::Mash.new({
        :access_token => 'access_code',
        :user => {
          :id => '1',
          :full_name => 'Ryan Norman',
          :profile_picture => 'profile.jpg',
          :username => 'rsnorman'
        }
      }))


      user_params[:service_id].should eq '1'
      user_params[:service_type].should eq 'Instagram'
      user_params[:name].should eq 'Ryan Norman'
      user_params[:profile_image_url].should eq 'profile.jpg'
      user_params[:username].should eq 'rsnorman'
      user_params[:access_token].should eq 'access_code'
    end
  end
end
