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
end
