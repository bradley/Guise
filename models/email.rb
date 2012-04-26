class EmailConfirmation
	def initialize(email, md5_hash)
	  @email = email
	  @md5_hash = md5_hash
	  @return_address = "http://website.com/confirm/#{@email}/#{@md5_hash}"
	end

	def setup_email
	  @mail = Mail.new do
		from 'some.email@gmail.com'
		to @email
		subject 'Confirmation Email'
		body "Click here: #{@return_address}"
	  end
	  @mail = @mail.to_s
	end

	def deliver
	  # Read documentation here to get this working:
	  #   https://github.com/mikel/mail
	  #@mail.deliver!
	end
end