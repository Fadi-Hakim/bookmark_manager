require 'sinatra/base'
require_relative 'data_mapper_setup'
require 'sinatra/flash'


class MyApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  set :session_secret, 'super secret'

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
    link = Link.create(url: params[:url],
                  title: params[:title])
    tag_list = params[:tags].split
    tag_list.each {|tag|link.tags << Tag.create(name: tag)}
    link.save
    redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end


  post '/users' do
    @user = User.create(email: params[:email],
                      password: params[:password],
                      password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/links')
    else
      flash.now[:notice] = 'Password and confirmation password do not match'
      erb :'users/new'
    end
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

end
