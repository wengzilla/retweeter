class ApplicationController < Sinatra::Base
  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)

  # main contorller action
  get '/ifttt' do
    tweeter = Tweeter.new
    tweets = tweeter.search_hashtag("HBSLTV")
    erb "index.html".to_sym, :locals => { :tweets => tweets, :since => tweeter.last_retweeted_id }
  end

  # will be used to display 404 error pages
  not_found do
    erb 'not_found.html'.to_sym
  end
end