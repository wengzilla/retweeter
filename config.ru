require 'sinatra/base'
Dir.glob('./{models,controllers}/*.rb').each { |file| require file }

map('/') { run ApplicationController }