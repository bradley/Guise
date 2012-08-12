# encoding: utf-8
class CharlesTaylor < Controllers
	def speak!
		quote = "The same public discussion is deemed to pass through our debate today, and someone else’s earnest conversation tomorrow, and the newspaper interview Thursday and so on… ."
		conjure 'charles', 
			spoken: quote, 
			title: 'Charles Taylor'
	end
end