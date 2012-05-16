# encoding: utf-8
class App < Sinatra::Application
  get '/' do
  	@title = 'something'
    erb :home
  end
end