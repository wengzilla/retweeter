require 'bundler/setup'
Bundler.require

class App < Sinatra::Base
  get '/ifttt' do
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['RETWEETER_CONSUMER_KEY']
      config.consumer_secret     = ENV['RETWEETER_CONSUMER_SECRET']
      config.access_token        = ENV['RETWEETER_ACCESS_TOKEN']
      config.access_token_secret = ENV['RETWEETER_ACCESS_TOKEN_SECRET']
    end

    user_tweets = client.user_timeline("hbsltv")
    since_id = client.user_timeline.map(&:retweeted_status).map(&:id).max

    tweets = client.search("#HBSLTV -RT", :since_id => since_id).to_a.reverse.map do |tweet|
      begin
        client.retweet(tweet)
        tweet.text
      rescue Twitter::Error::Forbidden => e
        puts "#{e.to_s} => #{tweet.text}"
      end
    end

    erb "index.html".to_sym, :locals => { :tweets => tweets }
  end
end