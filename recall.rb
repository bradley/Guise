require 'rubygems'
require 'sinatra'
require	'data_mapper'

# Set up a new SQLite3 database in the current directory named recall.db
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")
# The first argument for the setup method is the name you wish to give the connection.
# We simply use the default.
# The second argument breaks down into access protocol (sqlite3 here), the usename, the server,
# the password, and whatever path information is needed to address the data-store on the server.

=begin
	About DataMapper:
	DataMapper is an Object Relational Mapper (ORM).
	ORM's create a virtual object database that can be used within the programming language.
	This essentially provides an interface that can be used in your code. 
	For example (taken from SO):
		Instead of constructing SQL to find the first user in a users table, we could do this:
		User.first
		Which would return us an instance of our user model, with the attributes of the first user in the users table.

=end 
	
class Note
	include DataMapper::Resource
	# When calling the Note class, DataMapper will create the table as 'Notes'.
	# Note: Notice that DataMapper automatically calls the table 'Notes' and not 'Note'?
	# 	The DataMapper convention (not required) for naming is to name your setup classes with singular (not plural) syntax.
	# 	I'm *guessing* that DataMapper will always attempt to make the associated table name plural.(?)
	# Inside the Note class we are actually setting up the the database schema (below), which will have 5 fields.
	property :id, Serial
	# Serial means that the id field will be an integer primary key and will auto increment.
	property :content, Text, :required => true
	property :complete, Boolean, :required => true, :default => false
	property :created_at, DateTime
	property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!
# The auto_upgrade! method tells DataMapper to automatically update the database to contain the tables
# and fields we have set, and to do so again if we make any changes to the schema.


get '/' do
	@notes = Note.all :order => :id.desc
	# Notes from the notes table are assigned to the @notes instance variable.
	# Note: Making @notes an instance variable allows us to access it from the view file.
	@title = 'All Notes'
	erb :home
end

post '/' do
	n = Note.new
	# Create a Note object. Thanks to the DataMapper ORM, Note.new represents a new row in the notes table.
	# Following this, we will populate the fields in our table as named in the Note class.
	n.content = params[:content]
	n.created_at = Time.now
	n.updated_at = Time.now
	n.save
	redirect '/'
end

get '/:id' do
	@note = Note.get params[:id]
	@title = "Edit note ##{params[:id]}"
	erb :edit
end

put '/:id' do
	n = Note.get params[:id]
	n.content = params[:content]
	n.complete = params[:complete] ? 1 : 0
	# Note: Above is a Ternary operator similar to that seen in PHP. (If :complete exists, set to 1, else 0)
	# FYI, checkboxes are only submitted with a form if it is checked.
	n.updated_at = Time.now
	n.save
	redirect '/'
end

get '/:id/delete' do
	@note = Note.get params[:id]
	@title = "Confirm deletion of note ##{params[:id]}"
	erb :delete
end

delete '/:id' do
	n = Note.get params[:id]
	n.destroy
	redirect '/'
end

get '/:id/complete' do  
  n = Note.get params[:id]  
  n.complete = n.complete ? 0 : 1 # flip it  
  n.updated_at = Time.now  
  n.save  
  redirect '/'  
end  




