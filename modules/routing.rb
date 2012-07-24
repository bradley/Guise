# encoding: utf-8
module Sinatra
	module Routing
		def as klass, &routing
			klass.new.instance_eval(&routing)
		end
	end
	register Routing
end