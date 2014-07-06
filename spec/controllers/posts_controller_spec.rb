require 'spec_helper'

describe PostsController do
  describe "#index" do
    let(:client) { Hashie::Mash.new(:user => {:full_name => "Ryan Norman"}) }
    let(:user_photo) { Hashie::Mash.new(:id => 1) }
    let(:tagged_photo) { Hashie::Mash.new(:id => 2) }

    before do
      User.stub(:all => [Hashie::Mash.new(:access_token => "access_token")])
      client.should_receive(:user_recent_media)
        .and_return([user_photo])
      client.should_receive(:tag_recent_media)
        .and_return([tagged_photo])
      Instagram.should_receive(:client)
        .at_least(:twice)
        .and_return(client)
    end

    it "should get a list of connected user instagram photos" do
      get :index
      assigns(:posts).should include user_photo
    end

    it "should get a list of tagged instagram photos" do
      get :index
      assigns(:posts).should include tagged_photo
    end
  end
end
