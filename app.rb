=begin
# encoding: utf-8
require 'rubygems'
require 'backports'
require 'sinatra'
require 'sinatra/flash' # Allows flash messages.
require 'sinatra/redirect_with_flash' # Allows flash messages.


#require_relative 'minify_resources'
# NOTE: From the Ruby Docs...
# require_relative complements the builtin method require by allowing 
# you to load a file that is relative to the file containing the require_relative statement.

class MyApp < Sinatra::Application
	enable :sessions
	#enable :run

	configure :production do
		set :clean_trace, true
		set :css_files, :blob
		set :js_files,  :blob
		MinifyResources.minify_all
	end

	configure :development do
		set :css_files, MinifyResources::CSS_FILES
		set :js_files,  MinifyResources::JS_FILES
	end

	helpers do
		#This includes a set of methods provided by Rack. We now have access to a h() method to escape HTML.
		include Rack::Utils
		alias_method :h, :escape_html
	end


end

require_relative 'helpers/init'
require_relative 'models/init'
require_relative 'routes/init'
=end

	['/', '/home', '/home/'].each do |path|
	  get path do

		#if @user then
		 # redirect "/user/#{@user.username}"
		#else
		  #redirect '/login'
		#end
		'hello world'
	  end
	end