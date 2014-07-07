require 'spec_helper'

describe SocialClient do
  let(:client) { SocialClient.create(:instagram) }

  describe ".create" do
    it "should return the Instagram client if initialized with 'instagram'" do
      InstagramClient.should_receive(:new)
      SocialClient.create('instagram')
    end

    it "should return the Twitter client if initialized with 'twitter'" do
      TwitterClient.should_receive(:new)
      SocialClient.create('twitter')
    end
  end
end
