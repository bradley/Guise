# encoding: utf-8
class App < Sinatra::Application
  get '/' do
    erb :home
  end
end