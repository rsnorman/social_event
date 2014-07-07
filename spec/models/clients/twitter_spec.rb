require 'spec_helper'

describe TwitterClient do
  let(:client) { TwitterClient.new }
  let(:auth_client) do
    TwitterOAuth::Client.new(
      :consumer_key => TwitterClient::CONSUMER_KEY,
      :consumer_secret => TwitterClient::CONSUMER_SECRET
    )
  end

  describe "#initialize" do
    it "should initalize a user client" do
      pending "Need to initialize a user client"
    end
  end

  describe "#authorize_url" do
    before do
      TwitterOAuth::Client.stub(:new => auth_client)
      auth_client.stub(:request_token => Hashie::Mash.new({
        :authorize_url => 'https://api.twitter.com/oauth/authorize?oauth_token=BRvqrGN0WxZUezytDRFn5mkkWwNCmA1OwKdw0xSfns',
        :token => 'token',
        :secret => 'secret'
      }))
    end

    it "should retrieve the twitter callback url" do
      client.authorize_url.should eq 'https://api.twitter.com/oauth/authorize?oauth_token=BRvqrGN0WxZUezytDRFn5mkkWwNCmA1OwKdw0xSfns'
    end

    it "should save the oauth request token pairs" do
      TwitterClient.class_variable_get("@@oauth_request_token_pairs")
        .should eq({
          "BRvqrGN0WxZUezytDRFn5mkkWwNCmA1OwKdw0xSfns" => {
            :token => "token",
            :secret => "secret"
          }
        })
    end
  end

  describe "#get_access_token" do
    it "should get the access token data" do
      TwitterClient.class_variable_set("@@oauth_request_token_pairs", {
        'oauth_token' => {
          :token => 'token',
          :secret => 'secret'
        }
      })

      TwitterOAuth::Client.any_instance.should_receive(:authorize)
        .with('token', 'secret', :oauth_verifier => 'oauth_verifier')
      client.get_access_token('oauth_token', 'oauth_verifier')
    end
  end

  describe "#auth_params" do
    it "should return an array with :code" do
      client.auth_params.should eq [:oauth_token, :oauth_verifier]
    end
  end

  describe "#user_params_from_access_token" do
    it "should return params for creating a user from instagram access token" do
      user = Hashie::Mash.new({
        :id => '1',
        :name => 'Ryan Norman',
        :screen_name => 'rsnorman'
      })

      Twitter::REST::Client.stub(:new => Hashie::Mash.new({
        :user => user
      }))

      user_params = client.user_params_from_access_token(Hashie::Mash.new({
        :token => 'token',
        :secret => 'secret'
      }))

      user_params[:service_id].should eq '1'
      user_params[:service_type].should eq 'Twitter'
      user_params[:name].should eq 'Ryan Norman'
      user_params[:username].should eq 'rsnorman'
      user_params[:access_token].should eq 'token'
      user_params[:access_secret].should eq 'secret'
    end
  end
end
