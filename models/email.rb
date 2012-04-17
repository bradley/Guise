class EmailConfirmation
	def initialize(email, md5_hash)
	  @email = email
	  @md5_hash = md5_hash
	  @return_address = "http://website.com/confirm/#{@email}/#{@md5_hash}"
	end

	def setup_email
	  @mail = Mail.new do
		from 'bradley.j.griffith@gmail.com'
		to @email
		subject 'test email'
		body "this is the body. click here: #{@return_address}"
	  end
	  @mail = @mail.to_s
	end

	def deliver
	  #@mail.deliver!
	end
end