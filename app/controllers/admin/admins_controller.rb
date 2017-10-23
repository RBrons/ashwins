class Admin::AdminsController < Admin::AdminController
  
  before_action do
    if action_name == 'set_unset'
      @resource = resource_class_with_condition.find(params[:id])
    end
  end

  def resource_class_with_condition
    Admin
  end

  def set_unset
    resource.update(admin: !resource.admin)
    redirect_to :back
  end

end

