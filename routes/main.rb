# encoding: utf-8
class MyApp < Sinatra::Application

	before do
	  if logged_in?
	  	@user = User.first(id: session[:user_id])
	  end
	end

	not_found do
  	  redirect '/404'
	end

	['/', '/home', '/home/'].each do |path|
	  get path do
		if @user then
		  redirect "/user/#{@user.username}"
		else
		  redirect '/login'
		end
	  end
	end

	['/user/:username', '/user/:username/', '/user', '/user/'].each do |path|
	  get path do
	  	@username = params[:username]

	  	if @username.nil?
	  	  @user ? (redirect "/user/#{@user.username}") : (redirect '/login') 
	  	end
        User.first(username: @username) ? (@title = @username) : (redirect '/404')
        
        erb :user
	  end
	end

	['/404', '/404/'].each do |path|
	  get path do
	  	@title = '404'
	  	erb :unfound
	  end
	end

end