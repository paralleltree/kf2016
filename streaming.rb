require 'twitter'
require './models/loader.rb'

token = {
  consumer_key: '',
  consumer_secret: '',
  access_token: '',
  access_token_secret: ''
}

@rest = Twitter::REST::Client.new(token)
@stream = Twitter::Streaming::Client.new(token)

Thread.new do
  @stream.filter(track: "#Kouryo2016,#koryosai,#工陵祭") do |st|
    case st
    when Twitter::Tweet
      next unless st.media.count > 0
      user = User.new(id: st.user.id, screen_name: st.user.screen_name, name: st.user.name, profile_image_url: st.user.profile_image_url_https).tap { |u| u.save }
      status = Status.new(id: st.id, user_id: st.user.id, text: st.text, url: st.url).tap { |s| s.save }
      st.media.each do |m|
        Medium.new(id: m.id, url: m.media_url, status_id: st.id).save
      end
    end
  end
end
