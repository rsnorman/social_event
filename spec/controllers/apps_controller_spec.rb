require 'spec_helper'

describe AppsController do
  describe "#index" do
    it "should assign the supported apps to an array" do
      get :index
      assigns(:apps).should eq [:instagram]
    end
  end

  context "authorization" do
    let(:social_client) { Hashie::Mash.new(:authorize_url => "http://callback.com") }

    before do
      SocialClient.should_receive(:create).with('instagram')
        .and_return(social_client)
    end

    describe "#auth" do
      it "should redirect to Instagram authorization" do
        social_client.should_receive(:authorize_url)
          .and_return("http://callback.com")

        get :auth, :id => 'instagram'
        response.should redirect_to "http://callback.com"
      end
    end

    describe "#callback" do
      let(:user) { Hashie::Mash.new(:id => 1) }

      it "should save the access token and profile details in newly created user" do
        social_client.should_receive(:auth_params).at_least(:once).and_return([:code])
        social_client.should_receive(:get_access_token).with('auth_code')
        social_client.stub(:user_params_from_access_token => {
          :id => 1
        })
        User.should_receive(:create).with(:id => 1).and_return(user)
        get :callback, :id => 'instagram', :code => "auth_code"
        assigns(:user).should eq user
      end
    end
  end
end
