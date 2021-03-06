class SocialClient
  def self.create(name, options = {})
    if name.to_sym == :instagram
      InstagramClient.new(options)
    elsif name.to_sym == :twitter
      TwitterClient.new(options)
    elsif name.to_sym == :facebook
      FacebookClient.new(options)
    end
  end
end
