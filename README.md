# sinatra-with-users 
A basic sinatra application with the basic amenities a user might expect.

## Basic Functionality

Users can:
- Create an account.
- Login/Logout.
- Edit the account information.
- Delete the account.

Basic error messages will be shown under related fields when there are validation errors. 

## Ideas
Let me know if you have any feedback. Im a newbie and would relish any chance to improve on any topic here.

## Requirements

Ruby 1.9.2

Gems:
- rubygems
- sinatra
- rack-flash
- sinatra-flash
- sqlite3
- dm-core
- dm-validations
- dm-timestamps
- dm-sqlite-adapter
- mail

## Usage

- `shotgun config.ru`
- `visit http://localhost:9393/`

## Thanks

I received varying levels of inspiration and guidance from the following sources:

The awesome Sinatra skeleton by Phrogz on StackOverflow
http://stackoverflow.com/questions/5015471/using-sinatra-for-larger-projects-via-multiple-files

Andrew Burgess' "Ruby for Newbies: Working with DataMapper"
http://net.tutsplus.com/tutorials/ruby/ruby-for-newbies-working-with-datamapper/

Dan Harper's "Singing with Sinatra" (and subsequent tutorials)
http://net.tutsplus.com/tutorials/ruby/singing-with-sinatra/

Additionally, I got some ideas from the following two github repos:
https://github.com/daddz/sinatra-dm-login
https://github.com/rziehl/Sinatra-User-Signup---Login

I might have forgotten someone. Sorry if I did!
