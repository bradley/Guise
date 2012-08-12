# encoding: utf-8
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