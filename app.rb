# encoding: utf-8
require 'sinatra'
require 'rack'

require_relative 'minify_resources'

class App < Sinatra::Application
  enable :sessions

  configure :production do
    set :css_files, MinifyResources::CSS_FILES
    set :js_files,  MinifyResources::JS_FILES
  end
=begin
  configure :production do
  	set :clean_trace, true
  	set :css_files, :blob
  	set :js_files,  :blob
  	MinifyResources.minify_all
  end
=end

  configure :development do
  	set :css_files, MinifyResources::CSS_FILES
  	set :js_files,  MinifyResources::JS_FILES
  end

  configure do
    set :original_caller, nil
  end

  helpers do
  	#This includes a set of methods provided by Rack. We now have access to a h() method to escape HTML.
  	include Rack::Utils
  	alias_method :h, :escape_html
  end
end

#Dir.glob("**/*.rb").each { |r| require_relative r }
require_relative 'helpers/init'
require_relative 'modules/init'
require_relative 'controllers/init'
require_relative 'models/init'
require_relative 'routes/init'
