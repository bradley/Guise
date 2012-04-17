
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/database.db")

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

	attr_accessor :current_password , :new_password , :password_confirmation

	AlphnumWithUnderscores = /\A_?[a-z0-9]_?(?:[a-z0-9]_?)*\z/i # Regexp for alphanumeric phrases with non-consecutive underscores.

	# Validations
	#
	# Some of the following validations are conditional or contextual or both.
	# Some of the following validations are on non-properties of the model but need to pass before an object can be saved.
	validates_format_of       :username              , :with => AlphnumWithUnderscores , :message => 'Username may only contain letters, numbers, and non-consecutive underscores.'

	validates_presence_of     :username              , :when => [ :create ]
	validates_format_of       :username              , :when => [ :create ] , :if => :username     , :with => AlphnumWithUnderscores , :message => 'Username may only contain letters, numbers, and non-consecutive underscores.'
	validates_length_of       :username              , :when => [ :create ] , :if => :username     , :within => 1..20
	validates_uniqueness_of   :username              , :when => [ :create ] , :if => :username
	validates_presence_of     :email                 , :when => [ :create ]
	validates_format_of       :email                 , :when => [ :create ] , :if => :email        , :as => :email_address
	validates_uniqueness_of   :email                 , :when => [ :create ] , :if => :email
	validates_presence_of     :password_confirmation , :when => [ :create ]
	validates_confirmation_of :password_confirmation , :when => [ :create ] , :confirm => :new_password , :message => 'Confirmation password must match password.'
	validates_presence_of     :new_password          , :when => [ :create ]
	validates_length_of       :new_password          , :when => [ :create ] , :within => 6..20
	validates_format_of       :new_password          , :when => [ :create ] , :with => AlphnumWithUnderscores , :message => 'Password may only contain letters, numbers, and non-consecutive underscores.'

	validates_with_method     :username              , :when => [ :login ] , :method => :verified_email?
	validates_with_method     :current_password      , :when => [ :login ] , :method => :correct_password?

	validates_format_of       :username              , :when => [ :update ] , :if => :username     , :with => AlphnumWithUnderscores , :message => 'Username may only contain letters, numbers, and non-consecutive underscores.'
	validates_length_of       :username              , :when => [ :update ] , :if => :username     , :within => 1..20
	validates_uniqueness_of   :username              , :when => [ :update ] , :if => :username
	validates_format_of       :email                 , :when => [ :update ] , :if => :email        , :as => :email_address
	validates_uniqueness_of   :email                 , :when => [ :update ] , :if => :email
	validates_with_method     :current_password      , :when => [ :update ] , :if => :new_password , :method => :correct_password?
	validates_presence_of     :password_confirmation , :when => [ :update ] , :if => :new_password
	validates_confirmation_of :password_confirmation , :when => [ :update ] , :if => :new_password , :confirm => :new_password , :message => 'Confirmation password must match password.'
	validates_length_of       :new_password          , :when => [ :update ] , :if => :new_password , :within => 6..20
	validates_format_of       :new_password          , :when => [ :update ] , :if => :new_password , :with => AlphnumWithUnderscores , :message => 'Password may only contain letters, numbers, and non-consecutive underscores.'

	def username=(new_username)
	  super new_username.downcase
	end

	def verified_email?
	  if @confirmed == true
	  	return true
	  else
	  	return [false, 'The email associated with this account has not yet been verified.']
	  end
	end

	def correct_password?
	  if (hash_password(@current_password, @salt)).eql?(@hashed_password)
	    return true
	  else
		return [false, 'Invalid Password']
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
end

configure :development do
  #DataMapper.auto_migrate! # Uncomment this to clear the database.
  DataMapper.auto_upgrade!
end
