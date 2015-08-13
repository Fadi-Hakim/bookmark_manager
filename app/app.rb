require 'sinatra/base'
require_relative 'data_mapper_setup'

class MyApp < Sinatra::Base

  get '/' do
    redirect to('/links')
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.create(url: params[:url],     # 1. Create a link
                  title: params[:title])
    tag  = Tag.create(name: params[:tag]) # 2. Create a tag for the link
    link.tags << tag                       # 3. Adding the tag to the link's DataMapper collection.
    link.save                              # 4. Saving the link.
    redirect to('/links')
  end

end
