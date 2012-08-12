# encoding: utf-8
class MaoZedong < Controllers
	def speak!
		quote = "There is great chaos under heaven – the situation is excellent."
		conjure 'mao', 
			spoken: quote, 
			title: 'Mao Zedong'
	end
end
