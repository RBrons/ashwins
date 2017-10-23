class Admin::AdminController < ApplicationController
  layout 'admin'
  helper_method :resources
  helper_method :resource
  helper_method :resource_class_with_condition
  
  before_action :access_authentication
  before_action :set_resource_id, only: [:destroy, :show]
  
  def index
    @resources = resource_class_with_condition.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    
    respond_to do |format|
      format.html
    end
  
  end
  
  def destroy
    resource.destroy
    redirect_to resources_url
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  private
  def set_resource_id
    @resource = resource_class_with_condition.find(params[:id])
  end

  private
  def resources
    @resources
  end
  
  def resource
    @resource
  end
  
  def resources_url
    resource_class_with_condition.resources_url
  end
  
  def access_authentication
    raise AdminAuthenticationError unless current_user.admin?
  end

end