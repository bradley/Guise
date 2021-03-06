# Guise
A simple sinatra application setup that allows for routing in the context of controllers.



## What it does

Using the 'as' method, the developer can wrap particular routes within the context of a controller class. 



## Example

If the user navigates to /mao or /charles, the correct response for the given individual will be rendered. Each route uses the 'speak!' method, but in the context of its controller class.

			
	class App < Sinatra::Application
	  # ========= Persona Management =========
	  as MaoZedong do |persona|
	    get '/mao' do 
	      persona.speak!                                             
	    end
	  end

	  as CharlesTaylor do |persona|
	    get '/charles' do
	      persona.speak!
	    end
	  end
	  # ========= /Persona Management =========
	end



## Extras (Bloat!)

This project contains some extra components that aren't necessary for the basic functionality of this demo but that I believe to be a nice starting place for any Sinatra Application. 



## Ideas

Let me know if you have any feedback. Im a newbie and would relish any chance to improve on any topic here.

## Requirements

Ruby 1.9.3

Note: The ruby version is set in the .rvmrc file.
Note: The dependencies for this app are handled with [Bundler](http://gembundler.com/).

Gems:

- rubygems

- sinatra

- jsmin

- cssmin



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
