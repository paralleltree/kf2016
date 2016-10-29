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
  User.find_or_initialize_by(id: st.user.id).tap do |user|
    user.screen_name = st.user.screen_name
    user.name = st.user.name
    user.created_at = st.user.created_at
    user.profile_image_url = st.user.profile_image_url_https.to_s.sub(/_[^_]+?(?=\.\w+\z$)/, '')
    user.save
  end

  Status.find_or_initialize_by(id: st.id).tap do |status|
    status.user_id = st.user.id
    status.text = st.text
    status.url = st.url
    status.created_at = st.created_at
    status.save
  end

  st.media.each do |m|
    Medium.find_or_initialize_by(id: m.id).tap do |medium|
      medium.url = m.media_url
      medium.status_id = st.id
      medium.save
    end
    true
  end
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
