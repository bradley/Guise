# encoding: utf-8
class MyApp < Sinatra::Application

	# =============== Login =================
	['/login', '/login/'].each do |path|
	  get path do
	    if @user # User is already logged in
	  	  redirect "/user/#{@user.username}"
	    else
	      @title = 'User Login'
	      erb :login
	    end
	  end
	end

	post '/login' do
	  username = params[:username]
	  password = params[:password]		

	  if @user = User.account_exists(username)
	  	@user.last_login = Time.now # Update user information
	  	@user.current_password = password
        if @user.save(:login)
		  	session[:user_id] = @user.id # Set session
		  	redirect "/user/#{@user.username}"
		else
		  @title = 'Error'
	  	  # Any errors will be shown using dm_validations method .errors.on(:property)
	  	  #   EX: if @user.errors.on(:username) ...
		  erb :login
		end
	  else
	  	@title = 'Error'
		@username_error = 'There is no account associated with this username or email.'
		erb :login
	  end
	end
	# ============== /Login =================

	# ============= New Account ==============
    ['/join', '/join/'].each do |path|
	  get path do
        if @user # User is already logged in.
      	  redirect "/user/#{@user.username}"
	    else
	      @title = 'Join'
	      erb :join
	    end
	  end
	end

	post '/join' do
	  username = params[:username]
	  email = params[:email]
	  new_password = params[:password]
	  password_confirmation = params[:password_confirmation]


	  salt = generate_salt
	  hashed_password = hash_password(new_password, salt)

	  @new_user = User.new(
	    username: username, 
	    email: email, 
	    new_password: new_password,
		password_confirmation: password_confirmation,
	    salt: salt,
	    hashed_password: hashed_password
	  )
	  
	  if @new_user.save(:create)
		confirm = EmailConfirmation.new(@new_user.email, @new_user.md5_hash)
		confirm.setup_email
		confirm.deliver
		redirect '/confirm'	
	  else
		@title = 'Error'
	  	# Any errors will be shown using dm_validations method .errors.on(:property)
	  	#   EX: if @user.errors.on(:username) ...		
		erb :join
	  end
	end
	# ============ /New Account =============

	# ======== Account Confirmation =========
	['/confirm', '/confirm/'].each do |path|
	  get path do
	  	if @user
	  	  @title = 'Account Confirmed'
	      @response_message = 'The email for this account has already been confirmed.'
	  	else
	      @title = 'Confirm'
	      @response_message = "Please follow the link we sent to the email you provided."
	    end
	    erb :confirm
	  end
	end

	get '/confirm/:email/:md5_hash' do
	  email = params[:email]
	  md5_hash = params[:md5_hash]

	  user = User.first(email: email)

	  if user # Email matches a user in the User table.
		if user.md5_hash == md5_hash # Given hash cooresponds to this user.
		  if user.confirmed == false # User has not yet verified email.
			user.confirmed = true   
			user.updated_at = Time.now  
		  	if user.save # User's data successfully updated.
		      @title = 'Account Confirmed'
		      @response_message = "Thanks #{user.username}. You login to your account."
		  	else # Unknown error.
		  	  @title = 'Confirmation Error'
		  	  @response_message = 'Something went wrong… Please try again.'
		  	end
		  else # User has already verified email.
		  	@title = 'Account Confirmed'
		    @response_message = 'The email for this account has already been confirmed.'
		  end
		else # Given hash does not coorespond to this user.
		  @title = 'Confirmation Error'
		  @response_message = 'The supplied key does not coorespond to the account associated with this email.'
		end
	  else # Email does not match a user in the User table.
		@title = 'Error'
		@response_message = 'This supplied email is not associated with any account.'
	  end
	  erb :confirm
	end
	# ======== /Account Confirmation =========

	# =============== Logout =================
	['/logout', '/logout/'].each do |path|
	  get path do
        session.clear
        redirect '/'
      end
	end
	# ============== /Logout ================

	# ========= Account Management ==========
	['/account', '/account/'].each do |path|
	  get path do
	  	if @user 
	  	  @title = @user.username
	  	  erb :account
	  	else
	  	  redirect '/login'
	  	end
	  end
	end

	post '/account' do
	  if @user # User is logged in
	    username = params[:username]
	    email = params[:email]
	    current_password = params[:current_password]
	    new_password = params[:password]
	    password_confirmation = params[:password_confirmation]

		@user.username = username if !username.empty? && username != @user.username
		@user.email = email if !email.empty? && email != @user.email

		@user.current_password = current_password unless new_password.empty?
		@user.new_password = new_password unless new_password.empty?
		@user.password_confirmation = password_confirmation unless new_password.empty?

		if @user.valid?(:update)
		  unless new_password.empty?
		  	salt = generate_salt
			hashed_password = hash_password(new_password, salt)

		  	@user.hashed_password = hashed_password
		  	@user.salt = salt
		  end
		  @user.save
		  redirect "/user/#{@user.username}"
	  	else
	  	  @title = 'Error'
	  	  # Any errors will be shown using dm_validations method .errors.on(:property)
	  	  #   EX: if @user.errors.on(:username) ...
		  erb :account
	  	end
	  else
		redirect '/login'
	  end
	end
	# ========= /Account Management =========
end