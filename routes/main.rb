# encoding: utf-8
class App < Sinatra::Application
  get '/' do
    "Hello World!"
  end
end