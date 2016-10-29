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
words = %w(#Koryosai2016 #Koryosai #工陵祭)

def parse(st)
  user = User.new(id: st.user.id, screen_name: st.user.screen_name, name: st.user.name,
                  created_at: st.user.created_at,
                  profile_image_url: st.user.profile_image_url_https.to_s.sub(/_[^_]+?(?=\.\w+\z$)/, '')).tap { |u| u.save }
  status = Status.new(id: st.id, user_id: st.user.id, text: st.text, url: st.url, created_at: st.created_at).tap { |s| s.save }
  st.media.each do |m|
    Medium.new(id: m.id, url: m.media_url, status_id: st.id).save
  end
  true
rescue => e
  false
end

@rest.search(words.join(" OR "), result_type: :recent, count: 100, exclude: :retweets).to_a.each do |st|
  next unless st.media.count > 0
  parse(st)
end

Thread.new do
  @stream.filter(track: words.join(",")) do |st|
    case st
    when Twitter::Tweet
      next if st.retweet?
      next unless st.media.count > 0
      parse(st)
    end
  end
end
