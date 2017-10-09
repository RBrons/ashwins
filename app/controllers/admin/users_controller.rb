class Admin::UsersController < Admin::AdminController
  
  before_action do
    if action_name == 'set_unset' || action_name == 'enable_disable'
      @resource = resource_class_with_condition.find(params[:id])
    end
  end
  
  def resource_class_with_condition
    User.where(admin: [false, nil])
  end
  
  def set_unset
    resource.update(admin: !resource.admin)
    redirect_to :back
  end

  def enable_disable
    resource.update(enabled: !resource.enabled)
    redirect_to :back
  end

  def user_invite
    
  end

end