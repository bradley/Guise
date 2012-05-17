# Set up a new postgres database in the current directory named recall.db
db_uri = URI.parse(ENV['DATABASE_URL']).to_s
DataMapper::setup(:default, db_uri)

# HACK - This has to be above the model definition to work
# If this isn't in a module then the User class can't use the helper method
module PasswordHasher
	def hash_password(password, salt)
		Digest::MD5.hexdigest(password+salt)
	end
end

include PasswordHasher

class User
	include DataMapper::Resource
	include PasswordHasher

	property :id                , Serial   , required: true, unique: true
  property :username          , String   , required: true, unique: true, length: 1..20
  property :email             , String   , required: true, format: :email_address, unique: true  
  property :salt              , String   , length: 32
  property :hashed_password   , String   , required: true, length: 64
  property :created_at        , DateTime
	property :updated_at        , DateTime
	property :last_login        , DateTime
	property :confirmed         , Boolean  , required: true, default: false
	property :md5_hash          , String   , unique: true, default: lambda{ |resource,prop| Digest::MD5.hexdigest(resource.email.downcase+resource.salt)}

	attr_accessor :current_password , :new_password , :password_confirmation , :success_messages

	ALPHANUM_WITH_UNDERSCORES = /\A_?[a-z0-9]_?(?:[a-z0-9]_?)*\z/i # Regexp for alphanumeric phrases with non-consecutive underscores.

	# Validations
	validates_format_of       :username              , :with => ALPHANUM_WITH_UNDERSCORES , :message => 'Alphanumeric only please.'

	validates_with_method     :current_password      , :when => [ :login ] , :method => :correct_password?
	validates_with_method     :username              , :when => [ :login ] , :method => :verified_email?	

	validates_presence_of     :username              , :when => [ :create ]                             , :message => 'What can we call you?'
	validates_presence_of     :email                 , :when => [ :create ]                             , :message => 'Please enter a valid email.'
	validates_presence_of     :new_password          , :when => [ :create ]                             , :message => 'Please enter a password.'
	validates_length_of       :new_password          , :when => [ :create ] , :within => 6..20	        , :message => 'Must be between 6 and 20 characters.'
	validates_presence_of     :password_confirmation , :when => [ :create ]                             , :message => 'Please confirm your password.'
	validates_confirmation_of :password_confirmation , :when => [ :create ] , :confirm => :new_password , :message => 'Passwords don\'t match.'

	validates_format_of       :username              , :when => [ :create, :update, :update_confirm ] , :if => :username     , :with => ALPHANUM_WITH_UNDERSCORES , :message => 'Alphanumeric only please.'
	validates_length_of       :username              , :when => [ :create, :update, :update_confirm ] , :if => :username     , :within => 1..20                   , :message => 'Must be between 1 and 20 characters.'
	validates_uniqueness_of   :username              , :when => [ :create, :update, :update_confirm ] , :if => :username                                          , :message => 'That username is taken.'
	validates_format_of       :email                 , :when => [ :create, :update, :update_confirm ] , :if => :email        , :as => :email_address              , :message => 'Not a valid email address.'
	validates_uniqueness_of   :email                 , :when => [ :create, :update, :update_confirm ] , :if => :email                                             , :message => 'That email is already in taken.'

	validates_presence_of     :username              , :when => [ :update, :update_confirm ]                                                        , :message => 'Username cannot be blank!'
	validates_presence_of     :email                 , :when => [ :update, :update_confirm ]                                                        , :message => 'Email cannot be blank!'
	validates_presence_of     :password_confirmation , :when => [ :update, :update_confirm ] , :if => :new_password                                 , :message => 'Please confirm your new password.'
	validates_confirmation_of :password_confirmation , :when => [ :update, :update_confirm ]                        , :confirm => :new_password     , :message => 'Passwords don\'t match.'
	validates_length_of       :new_password          , :when => [ :update, :update_confirm ] , :if => :new_password , :within => 6..20              , :message => 'Must be between 6 and 20 characters.'

	validates_length_of       :current_password      , :when => [ :update_confirm ] , :if => :current_password , :min => 1                     , :message => 'Password required to update information.'
	validates_with_method     :current_password      , :when => [ :update_confirm ] , :if => :current_password , :method => :correct_password?


	def username=(new_username)
	  super new_username.downcase
	end

	def verified_email?
	  if @confirmed == true
	  	return true
	  else
	  	return [false, 'The email for this account has not been validated.']
	  end
	end

	def correct_password?
	  if (hash_password(@current_password, @salt)).eql?(@hashed_password)
	    return true
	  else
		return [false, 'Wrong password!']
	  end
	end

    def self.account_exists(login)
      if user = User.first(username: login)
      	return user
      elsif user = User.first(email: login)
      	return user
      else
      	return nil
      end
    end

    def is_valid_messages
      success_messages = {
      	:username => ['Looks good!', 'That\'s you!'], 
      	:email => ['Available!', 'That\'s your email!'], 
      	:new_password => ['Could be better.', 'Good.', 'Very nice.'], 
      	:password_confirmation => ''
      }
      return success_messages
    end
end

configure :development do
  #DataMapper.auto_migrate! # Uncomment this out to clear database.
  DataMapper.auto_upgrade!  # Do the above and comment this out to clear database.
end



module ValidMessages
  def return_valid_messages(validation_content)
  	user = validation_content.user
  	input_data = validation_content.input_data
	return_messages = Hash.new
	success_messages = user.is_valid_messages

    input_data.each_pair do |key,val|
	  key = key.to_sym
	  case key
	  when :username
		if user && !user.attribute_dirty?(:username)
	      return_messages[:username] = success_messages[:username][1]
   	    else
		  return_messages[:username] = success_messages[:username][0]
		end
	  when :email
		if user && !user.attribute_dirty?(:email)
		  return_messages[:email] = success_messages[:email][1]
		else
		  return_messages[:email] = success_messages[:email][0]
		end
	  when :new_password
		if input_data['new_password'] =~ /.*[\W].*[A-Z].*[0-9]/i && input_data['new_password'] =~ /.{6,}/
		  return_messages[:new_password] = success_messages[:new_password][2]
		elsif input_data['new_password'] =~ /.*[A-Z].*[0-9]/i && input_data['new_password'] =~ /.{6,}/
		  return_messages[:new_password] = success_messages[:new_password][1]
		elsif input_data['new_password'] =~ /.{6,}/
		  return_messages[:new_password] = success_messages[:new_password][0]
		end
	  else
		return_messages[key] = ''
	  end
	end
	return return_messages
  end
end

class ValidateProperties
  attr_accessor :formatter,:context,:input_data,:user

  def initialize(formatter,context,input_data,user)
  	@formatter = formatter
  	@context = context.to_sym
  	@input_data = input_data
  	@user = user

  	@input_valid_hash
  end

  def process_validation
  	# Strategy
  	@formatter.process_validation(self)
  end

  def valid_with_context?
  	@user.valid?(@context)
  end

  def return_error_messages
  	input_error_hash = Hash.new
  	@user.errors.each_pair do |key, value|
  	  input_error_hash[key] = value[0]
  	end
  	return input_error_hash
  end

  def return_valid_messages
  	@formatter.return_valid_messages(self)
  end
end

# Strategy
class ValidateWithUpdate
  include ValidMessages
  def process_validation(validation_content)
  	validation_content.input_data.each_pair do |key, val|
  	  key = key.to_sym
	  val = val.to_s

	  case key
	  when :username
	    validation_content.user.attributes = {key => val} unless val == validation_content.user.username
	  when :email
	    validation_content.user.attributes = {key => val} unless val == validation_content.user.email
	  when :new_password
	    validation_content.user.attributes = {key => val} unless val.empty?
	  when :password_confirmation
	    validation_content.user.attributes = {key => val} unless val.empty? && validation_content.input_data['new_password'].empty?
	  when :current_password
	      validation_content.user.attributes = {key => val} if !validation_content.user.dirty_attributes.empty? || validation_content.user.new_password 
	  end 
	end
  end
end

class DeleteMe
  def initialize
    @db_uri = URI.parse(ENV['DATABASE_URL']).to_s
  end

  def get_nonsense
    return @db_uri
  end
end

# Strategy
class ValidateWithCreate
  include ValidMessages
  def process_validation(validation_content)
  	validation_content.input_data.each_pair do |key, val|

  	  key = key.to_sym
	  val = val.to_s

	  case key
	  when :username
	    validation_content.user.attributes = {key => val}
	  when :email
	    validation_content.user.attributes = {key => val}
	  when :new_password
	    validation_content.user.attributes = {key => val}
	  when :password_confirmation
	    validation_content.user.attributes = {key => val}
	  end 
	end
  end
end