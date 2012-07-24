# encoding: utf-8
class App < Sinatra::Application
  SITE_NAME = "Situational Change"
  DEFAULT_TITLE = "Guise"

  before do
    @site_name = SITE_NAME
    @title = DEFAULT_TITLE
  end

  not_found do
  	redirect '/404'
  end

  ['/', '/home', '/home/'].each do |path|
  	get path do
  	  erb :home
  	end
  end

  ['/404', '/404/'].each do |path|
  	get path do
  	  @title = '404'
  	  erb :unfound
  	end
  end
end