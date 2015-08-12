require 'sinatra/base'

class MyApp < Sinatra::Base
  get '/links' do
    @links = Link.all
    erb :'links/index'
  end
end
