require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'JiWURDCpVYMkMdEh4RZGIdRua'
  config.consumer_secret = 'DtspDRqz2nvNbIv0tNYK9fPH6nEJ0HzxUdd4bXkoX31yTPusqC'
  config.access_token = '2830097575-ZMXbUfcueQjin0WPvzLdj6e79T0ygUmHmVX7CbH'
  config.access_token_secret = 'h5NrVHTK3n9wZRoeyppuJPtaB1ejc3Kg7keTol1b30oW6'
end

search_term = URI::encode('@thenetbook')

SCHEDULER.every '20s', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
   rescue Twitter::Error => e
    puts "Twitter Error: #{e}"
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end 