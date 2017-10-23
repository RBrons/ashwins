class AdminMailer < ActionMailer::Base
  default from: 'no-reply@messenger-test.herokuapp.com'
  
  def forgot_password(admin = Admin.first)
    @auto_login_token = SecureRandom.hex(100)
    admin.update(:auto_login_token => @auto_login_token)
    puts 'working.............'
    @host = HOST
    mail(to: admin.email, subject: 'forgot password ?')
  end
  
  def gmail_api_error error
    @error = error
    mail(to: 'akash.kr211@gmail.com', subject: 'Gmail API error')
  end

   def welcome_user(user)
    @user = user
    mail(:to => user.email, :subject => 'Welcome to Dvnomessenger')
  end

  def user_approval_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => 'User approval confirmation')
  end

  def notification_to_admin(user)
    @user = user
    mail(:to => "danhalper@gmail.com", :subject => 'New user registered on Dvno messenger')
  end

end
