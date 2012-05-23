# encoding: utf-8
class App < Sinatra::Application
  get '/list' do
    @users = User.all
    erb :list
  end

  ['/search', '/search/'].each do |path|
  get path do
    if @user 
      @title = 'Find People'
      erb :search
    else
      redirect '/login'
    end
  end
  end

  post '/search' do
    @title = 'Find People'
    search_query = params[:search]
    unless @match = User.first(:username => search_query)
      @no_match = 'No match found.'
    end
    erb :search
  end

end