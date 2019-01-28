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
    erb :posts, locals: {gossip: Gossip.find(asked_index), index: asked_index}
  end

  get '/gossip/edit/*' do |asked_index|
    erb :edit, locals: {gossip_edit: Gossip.find(asked_index[0].to_i), index: asked_index[0].to_i}
  end

  post '/gossip/edit/*' do |asked_index|
    Gossip.update(asked_index[0].to_i, params["gossip_content"])
    redirect "/gossip/#{asked_index[0]}"
  end
end
