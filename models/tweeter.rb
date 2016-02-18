require 'twitter'

class Tweeter
  USER = "hbsltv"

  def initialize
  end

  def retweet!(hashtag)
    search_hashtag(hashtag).map do |tweet|
      begin
        client.retweet(tweet)
        tweet
      rescue Twitter::Error::Forbidden => e
        puts "#{e.to_s} => #{tweet.text}"
      end
    end
  end

  def search_hashtag(hashtag)
    client.search("##{hashtag} -RT", :since_id => last_retweeted_id).to_a.reverse
  end

  def last_retweeted_id
    user_timeline.map(&:retweeted_status).map(&:id).max
  end

  private

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['RETWEETER_CONSUMER_KEY']
      config.consumer_secret     = ENV['RETWEETER_CONSUMER_SECRET']
      config.access_token        = ENV['RETWEETER_ACCESS_TOKEN']
      config.access_token_secret = ENV['RETWEETER_ACCESS_TOKEN_SECRET']
    end
  end

  def user_timeline
    client.user_timeline(USER)
  end
end