require 'twitter'

#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'JiWURDCpVYMkMdEh4RZGIdRua'
  config.consumer_secret = 'DtspDRqz2nvNbIv0tNYK9fPH6nEJ0HzxUdd4bXkoX31yTPusqC'
  config.access_token = '2830097575-ZMXbUfcueQjin0WPvzLdj6e79T0ygUmHmVX7CbH'
  config.access_token_secret = 'h5NrVHTK3n9wZRoeyppuJPtaB1ejc3Kg7keTol1b30oW6'
end

SCHEDULER.every '20s', :first_in => 0 do |job|
  begin
    timeline = twitter.mentions_timeline
    if timeline
      mentions = timeline.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', {comments: mentions})
    end
  rescue Twitter::Error
    puts "\e[33mThere was an error with Twitter\e[0m"
  end
end