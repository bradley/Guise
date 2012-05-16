# encoding: utf-8
require 'sinatra'
require 'rack'

require_relative 'minify_resources'

class App < Sinatra::Application

end

require_relative 'helpers/init'
require_relative 'routes/init'