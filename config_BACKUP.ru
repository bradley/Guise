ENV['GEM_HOME'] = '/home/bradleygriffith/.gems'
ENV['GEM_PATH'] = '$GEM_HOME:/usr/lib/ruby/gems/1.8'  
require 'rubygems' 
require 'vendor/rack-1.4.1/lib/rack'
require 'vendor/sinatra-1.3.2/lib/sinatra'
require '/home/bradleygriffith/.gems/gems/tilt-1.3.3/lib/tilt'
require 'vendor/extensions-0.6.0/lib/extensions/all.rb'
Gem.clear_paths


disable :run, :reload

set :environment, :production



root = ::File.dirname(__FILE__)
require ::File.join( root, './app' )
run MyApp.new