class EmailConfirmation
	def initialize(email, md5_hash)
	  @email = email
	  @md5_hash = md5_hash
	  @return_address = "http://website.com/confirm/#{@email}/#{@md5_hash}"
	end

	def setup_email
	  # Find email options for Heroku, e.g.; SendGrid
	end

	def deliver
	   # Find email options for Heroku, e.g.; SendGrid
	end
end