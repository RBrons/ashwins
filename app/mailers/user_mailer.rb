class UserMailer < ActionMailer::Base
  default from: 'datadownloading.com@gmail.com'
  layout '1031_exchange'

  def forgot_password(user_id)
    user = User.find(user_id)
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
    mail(:to => 'danhalper@gmail.com', :subject => 'New user registered on Dvno messenger')
  end

  def work_group_access_notify(user_id)
    user = User.find(user_id)
  end

  def work_group_access_notify_with_signup(options)
    @work_group            = options[:work_group]
    @owner_name_with_email = options[:owner_name_with_email]
    @permission_type       = options[:permission_type]
    @user                  = options[:user]
    @work_group_id         = options[:work_group_id]
    mail(:to => @user.email, :subject => "Your have access to #{@work_group}")
  end

end
