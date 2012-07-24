# encoding: utf-8
class App < Sinatra::Application
	# ========= Persona Management =========
	as MaoZedong do |persona|
		get '/mao' do 
			@title = 'Mao Zedong'
		  @spoken = persona.speak!          
			erb :mao                                      
		end
	end

	as CharlesTaylor do |persona|
		get '/charles' do
			@title = 'Charles Taylor'
			@spoken = persona.speak!
			erb :charles
		end
	end
	# ========= /Persona Management =========
end