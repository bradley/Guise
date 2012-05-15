Gem.clear_paths
ENV['GEM_HOME'] = '/home/bradleygriffith/.gem'
ENV['GEM_PATH'] = '/home/bradleygriffith/.gem:/usr/lib/ruby/gems/1.8'
require 'rubygems'
require 'bundler'
Bundler.require

set :environment, :development
set :views, File.dirname(__FILE__) + '/views'

# Enables error logging
log = File.new("sinatra.log", "w")
STDOUT.reopen(log)
STDERR.reopen(log)

root = ::File.dirname(__FILE__)
require ::File.join( root, './app' )
run MyApp.new