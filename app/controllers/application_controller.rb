class UnauthorizedError < Exception;
end

class AdminAuthenticationError < StandardError
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from UnauthorizedError, :with => :invalid_access_render
  rescue_from AdminAuthenticationError, :with => :invalid_access_render
  protect_from_forgery with: :exception
  include ApplicationHelper
  helper_method :sessioned_per_page

  before_action :save_current_url
  # before_filter :ability, :last_active
  before_action :authenticate_user!
  before_action :user_enabled
  before_action :miniprofiler
  before_action :check_member_init


  def save_current_url
    if !current_user.try(:email).blank?
      unless ['/', '/users/sign_in'].include?(current_FULLPATH)
        session[:last_url] ||= current_FULLPATH
        puts session[:last_url]
      end
      if ['/users/sign_out'].include?(current_FULLPATH)
        # Save last page before sign out
        previous_url = request.referer
        @user = current_user
        if URI(previous_url).path != '/'
          @user.last_sign_out_page = previous_url
        else
          @user.last_sign_out_page = nil
        end
        @user.save
      end
    end
  end

  def check_member_init
    MemberType.InitMemberTypes if (MemberType.objects.nil? || MemberType.objects.empty?)
  end

  protected

  def admin
    begin
      @admin_namespace     = params[:controller].include?('admin/')
      @admin_email, @admin = session[:admin_email], session[:admin]
    rescue Exception => e
      @admin_namespace = false
      Error.send e
    end
  end

  def create_admin_session email, admin
    session[:admin_email], session[:admin] = email, admin
    admin.update_columns(:total_login => admin.total_login+1, :last_login => Time.now)
  rescue => e
    Error.send e
  end

  def auto_create_admin_session email
    admin = Admin.find_by(email: email)
    if admin
      create_admin_session email, admin
    end
  rescue => e
    Error.send e
  end

  def admin_authentication
    if @admin.blank? || @admin_email.blank?
      redirect_to admin_get_login_path
    end
  end

  def user_block_or_trash
    if current_user && (current_user.blocked || current_user.trash)
      sign_out current_user
      # flash[:alert] = "This account has been suspended for violation of...."
      render :layout => 'suspended_account', :template => 'home/account_suspended' and return
    elsif current_user && current_user.trash?
      sign_out current_user
      redirect_to '/'
    end
  end

  def user_enabled
    if current_user && !current_user.enabled
      sign_out current_user
      # flash[:alert] = 'Please be patient, the administrator will enable your account very soon.'
      redirect_to '/'
    end
  end

  def check_user_approval
    unless current_user.user_approval
      redirect_to social_index_path(notifyApproval: true)
    end
    if current_user.approval_msg || current_user.services.where(provider: "google_oauth2").blank?
      redirect_to social_index_path
    end
  end

  def ability
    unless current_user.blank?
      @ability = current_user.ability
      if @ability.blank?
        raise NoUserRelationWithAbilityFound
      end
    end
  end

  def defaultize(obj, mode=nil)
    defVals = DefaultValue.where(entity_name: obj.class.name)
    defVals = defVals.where(mode: mode) if !mode.nil?
    defVals.each do |val|
      val_ = val.value
      if val.value_type == 'Amount'
        begin
          val_ = val_.to_f
        rescue => exception
          val_ = 0.00
        end
      elsif val.value_type == 'Integer'
        begin
          val_ = val_.to_i
        rescue => exception
          val_ = 0
        end
      elsif val.value_type == 'Random US City'
        val_ = US_CITIES.sample
      elsif val.value_type == 'Random Tenant'
        val_ = Tenant.where.not(name: 'No Tenant').pluck('id').sample
      elsif val.value_type == 'Random Rent'
        val_ =  5000 + rand(95000) # (500..10000).to_a.sample
      elsif val.value_type == 'Random Cap Rate'
        val_ = 1 + rand(10)
      elsif val.value_type == 'Random Owner'
        if obj.try(:ostatus) == 'Purchased'
          val_ = Entity.all.pluck('id').sample
        elsif obj.try(:ostatus) == 'Prospective Purchase'
          val_ = Contact.where(role: 'Counter-Party').pluck('id').sample
        end
      elsif val.value_type == 'Random Seller'
        val_ = Property.where(ownership_status: 'Purchased').pluck('id').sample
      end
      obj.try("#{val.attribute_name.underscore}=".to_sym, val_)
    end
    return obj
  end

  private
  def last_active
    unless current_user.blank?
      current_user.touch(:last_active)
    end
  rescue Exception => e
    puts e.message
    puts e.backtrace
  end

  def invalid_access_render
    respond_to do |type|
      type.js { render :text => "Unauthorized Error", :status => 401, :layout => false }
      type.all { render :file => File.join(Rails.root, 'public/401.html'), :status => 401, :layout => false }
    end
    true
  end

  def entity_check
    raise UnauthorizedError unless AccessResource.can_access?(user: current_user, resource: @entity)
  end

  def miniprofiler
    Rack::MiniProfiler.authorize_request if Rails.env.development?
  end

  public
  def after_sign_in_path_for(resource)
    last_url           = session[:last_url]
    session[:last_url] = nil
    last_url || '/'
  end

  def common_multi_delete
    ids    = params[:multi_delete_objects]
    ids    = ids.split(',').map(&:to_i).compact
    klazzz = params[:klazzz].split(',').map(&:strip)
    klazzz.each do |klazz|
      updated_to = Time.now unless params[:untrashed].to_b
      updated_to = nil if params[:untrashed].to_b
      klazz.to_s.constantize.with_deleted.where(id: ids).update_all(deleted_at: updated_to)
    end
    redirect_to :back
  end

  def sessioned_per_page(per_page=false)
    if per_page != false && !nil_or_zero(per_page)
      session[:per_page] = per_page
    else
      nil_or_zero(session[:per_page]) ? 10 : session[:per_page]
    end
  end

end

class NoUserRelationWithAbilityFound < Exception;
end
