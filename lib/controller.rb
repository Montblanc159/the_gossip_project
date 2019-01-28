require 'gossip'

class ApplicationController < Sinatra::Base
  get '/' do
    erb :index, locals: {gossips: Gossip.all}
  end

  get '/gossip/new' do
    erb :new_gossip
  end

  post '/gossip/new' do
    Gossip.new(params["gossip_author"], params["gossip_content"]).save
    redirect '/'
  end

  get '/gossip/:asked_index' do |asked_index|
    puts Gossip.all
    puts Gossip.find(asked_index)
    erb :posts, locals: {gossip: Gossip.find(asked_index), index: asked_index}
  end
end
