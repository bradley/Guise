module AccountAssisters
  def logged_in?
    if session[:user_id]
      true
    else
      false
    end
  end

  def generate_salt
    rng = Random.new
    Array.new(User.salt.length){ rng.rand(33...126).chr }.join
  end

  #Flash helper based on the one from here:
  #https://github.com/daddz/sinatra-dm-login/blob/master/helpers/sinatra.rb 
  def show_flash(key)
    if session[key]
      flash = session[key]
      session[key] = false
      flash
    end
  end
end

module PasswordHasher
  def hash_password(password, salt)
    Digest::MD5.hexdigest(password.to_s+salt.to_s)
  end
end