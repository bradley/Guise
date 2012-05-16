require 'sinatra'

class MyApp < Sinatra::Application
  get '/' do
    "Hello World!"
  end
end