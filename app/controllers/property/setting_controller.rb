class Property::SettingController < ApplicationController
  def index
    key      = params[:id]
    @property = Property.find_by(key: key)
    if request.post?
      email           = params[:email]
      if email.email?
        user   = User.find_by(email: email)
        user ||= Users::Unregistered.find_or_create_by(email: email)
        access_resource = AccessResource.find_or_create_by(resource_id: @property.id, resource_klass: @property.class.to_s, unregistered_u_k: user.key)
        access_resource.permission_type = params[:permission_type]
        access_resource.can_access = (user.class.to_s == 'User')
        access_resource.save
        ######### Send Email Notification #########
        options                         = {}
        options[:user]                  = user
        options[:work_group]            = @property.title
        options[:owner_name_with_email] = "<#{current_user.email}>"
        options[:permission_type]       = access_resource.permission_type_
        options[:work_group_id]         = @property.key
        UserMailer.work_group_access_notify_with_signup(options).deliver
        ######### Send Email Notification #########
      else
        flash[:notice] = 'Invalid Email'
      end
    end
    render layout: false
  end

  def emails
    if request.delete?
      key      = params[:id]
      property = Property.find_by(key: key)
      email           = params[:email]
      if email.email?
        user            = User.find_by(email: email)
        user          ||= Users::Unregistered.find_or_create_by(email: email)
        access_resource = AccessResource.find_or_create_by(resource_id: property.id, resource_klass: property.class.to_s, user_id: user.id)
        access_resource.delete
      else
        flash[:notice] = 'Invalid Email'
      end
      return redirect_to :back
    end
    emails = User.select(:email).where('email LIKE ?', "%#{params[:email]}%").pluck(:email)
    if emails.blank?
      emails = ['No Record Found !']
    end
    render json: emails.to_json
  end
end
