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

	# TODO: This should probably be handled with the ValidProperties class like other post routes do in this file.
	post '/login' do
	  username = params[:username]
	  password = params[:password]		

	  if @login = User.account_exists(username)
	  	@login.last_login = Time.now # Update user information
	  	@login.current_password = password
        if @login.save(:login)
		  	session[:user_id] = @login.id # Set session
		  	redirect "/user/#{@login.username}"
		else
		  @title = 'Error'
	  	  # Any errors will be shown using dm_validations method .errors.on(:property)
	  	  #   EX: if @user.errors.on(:username) ...
		  erb :login
		end
	  else
	  	@title = 'Error'
	  	if username.empty?
	      @username_error = 'Please enter your username or email address.'
	  	else
		  @username_error = 'There is no account associated with this username or email.'
		end
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
	  input_data = params
	  context = :create

	  @new_user = User.new

	  unless input_data[:new_password].empty?
		input_data[:salt] = generate_salt
		input_data[:hashed_password] = hash_password(input_data[:new_password], salt)
	  end
	  
	  validate_user = ValidateProperties.new(ValidateWithCreate.new,context,input_data,@new_user)
	  validate_user.process_validation

	  if validate_user.valid_with_context? && @new_user.save(context)
		confirm = EmailConfirmation.new(@new_user.email, @new_user.md5_hash)
		confirm.setup_email
		confirm.deliver
		redirect '/confirm'	
	  else
		@title = 'Error'
		@error_messages = validate_user.return_error_messages	
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
	      user = User.first(username: 'test')
	      #@response_message = "Please follow the link we sent to the email you provided."
	      @response_message = user.md5_hash
	    end
	    erb :confirm
	  end
	end

	get '/confirm/:email/:md5_hash' do
	  email = params[:email]
	  md5_hash = params[:md5_hash]
	  # The 'first' method, in DataMapper, returns the first row to contain the give key => value pair.
	  # The 'all' method returns a hash of all the rows tha match the query. There is also a 'last' method... guess what that means!
	  # These methods are similar to the mysql query 'SELECT * FROM user_table WHERE username = 'bradleygriffith''
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
	  	input_data = params
	    context = :update_confirm

	    validate_user = ValidateProperties.new(ValidateWithUpdate.new,context,input_data,@user)
	    validate_user.process_validation

	    if validate_user.valid_with_context? 
		  unless params[:new_password].empty?
		  	salt = generate_salt
			hashed_password = hash_password(params[:new_password], salt)

		  	@user.hashed_password = hashed_password
		  	@user.salt = salt
		  end
		  @user.save
		  redirect "/user/#{@user.username}"	
	    else
		  @title = 'Error'
		  @error_messages = validate_user.return_error_messages
		  erb :account
	    end
	  else
		redirect '/login'
	  end
	end
	# ========= /Account Management =========
end