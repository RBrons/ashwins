class Entities::JointTenancyController < ApplicationController

  layout "entities"

  before_action :current_page
  before_action :set_entity, only: [:basic_info]
  
  def basic_info
    #key = params[:entity_key]
    if request.get?
      #@entity = Entity.find_by(key: key)
      #if @entity.present?
      #  entity_check()
      #  @entity = EntityJointTenancy.find_by(key: key)
      #end
      @entity       ||= EntityJointTenancy.new(type_: params[:type])
      if @entity.new_record?
        add_breadcrumb "Clients", clients_path, :title => "Clients"
        add_breadcrumb "Joint Tenancy", '',  :title => "Joint Tenancy"
        add_breadcrumb "Create", '',  :title => "Create"
      else
        add_breadcrumb "Clients", clients_path, :title => "Clients"
        add_breadcrumb "Joint Tenancy", '',  :title => "Joint Tenancy"
        add_breadcrumb "Edit: #{@entity.name}", '',  :title => "Edit"
        add_breadcrumb "Basic Info", '',  :title => "Basic Info"
      end
    elsif request.post?
      @entity                 = EntityJointTenancy.new(entity_joint_tenancy_params)
      @entity.type_           = MemberType.getJointTenancyId
      @entity.basic_info_only = true
      @entity.user_id         = current_user.id

      if @entity.save
        AccessResource.add_access({ user: current_user, resource: Entity.find(@entity.id) })
        flash[:success] = "Congratulations, you have just created a record for #{@entity.name}"
        return redirect_to entities_joint_tenancy_basic_info_path(@entity.key)
      end
    elsif request.patch?
      #@entity                 = EntityJointTenancy.find_by(key: key)
      prior_entity_name = @entity.name
      @entity.type_           = MemberType.getJointTenancyId
      @entity.basic_info_only = true
      if @entity.update(entity_joint_tenancy_params)
        flash[:success] = "Congratulations, you have just made a change in the record for #{prior_entity_name}"
        return redirect_to entities_joint_tenancy_basic_info_path(@entity.key)
      end
    else
      raise UnknownRequestFormat
    end
    render layout: false if request.xhr?
  end

  # tenants_in_common
  def joint_tenant
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @joint_tenant                 = JointTenant.find(id) if id.present?
      @joint_tenant                 ||= JointTenant.new
      @joint_tenant.super_entity_id = @entity.id
      if request.get?
        if @joint_tenant.new_record?
          add_breadcrumb "Clients", clients_path, :title => "Clients"
          add_breadcrumb "Joint Tenancy", '',  :title => "Joint Tenancy"
          add_breadcrumb "Edit: #{@entity.name}", '',  :title => "Edit"
          add_breadcrumb "Joint Tenant Create", '',  :title => "Joint Tenant Create"
        else
          add_breadcrumb "Clients", clients_path, :title => "Clients"
          add_breadcrumb "Joint Tenancy", '',  :title => "Joint Tenancy"
          add_breadcrumb "Edit: #{@entity.name}", '',  :title => "Edit"
          add_breadcrumb "Joint Tenant", '',  :title => "Joint Tenant"
        end
      end
    end
    if request.post?
      @joint_tenant                 = JointTenant.new(joint_tenant_params)
      @joint_tenant.super_entity_id = @entity.id
      @joint_tenant.class_name      = "JointTenant"
      @joint_tenant.use_temp_id
      if @joint_tenant.save
        @joint_tenants = @joint_tenant.super_entity.joint_tenants
        flash[:success] = "Congratulations, you have just created a record for #{@joint_tenant.first_name} #{@joint_tenant.last_name}, a Joint Tenant of #{@entity.name}"
        return redirect_to entities_joint_tenancy_joint_tenants_path(@entity.key)
      else
        return redirect_to entities_joint_tenancy_joint_tenant_path(@entity.key, @joint_tenant)
      end
    elsif request.patch?
      prior_joint_tenant_name = "#{@joint_tenant.first_name} #{@joint_tenant.last_name}"
      if @joint_tenant.update(joint_tenant_params)
        @joint_tenant.use_temp_id
        @joint_tenant.save
        @joint_tenants = @joint_tenant.super_entity.joint_tenants
        
        flash[:success] = "Congratulations, you have just made a change in the record for #{prior_joint_tenant_name}, a Joint Tenant of #{@entity.name}"
        return redirect_to entities_joint_tenancy_joint_tenants_path(@entity.key)
      else
        return redirect_to entities_joint_tenancy_joint_tenant_path(@entity.key, @joint_tenant.id)
      end
    elsif request.delete?
      joint_tenant = JointTenant.find(params[:id])
      joint_tenant.delete
      @entity        = joint_tenant.super_entity
      @joint_tenants = @entity.joint_tenants
      return redirect_to entities_joint_tenancy_joint_tenants_path(@entity.key)
    end
    @joint_tenant.gen_temp_id
    render layout: false if request.xhr?
  end

  def joint_tenants
    @entity = Entity.find_by(key: params[:entity_key])
    @entity = Entity.find_by(key: params[:entity_key])
    add_breadcrumb "Clients", clients_path, :title => "Clients"
    add_breadcrumb "Joint Tenancy", '',  :title => "Joint Tenancy"
    add_breadcrumb "Edit: #{@entity.name}", '',  :title => "Edit"
    add_breadcrumb "Joint Tenants List View", '',  :title => "Joint Tenants List View"
    
    raise ActiveRecord::RecordNotFound if @entity.blank?
    @joint_tenants = @entity.joint_tenants
    render layout: false if request.xhr?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  private
  def entity_joint_tenancy_params
    params.require(:entity_joint_tenancy).permit(:name, :name2, :address, :type_, :jurisdiction, :number_of_assets,
                                                 :first_name, :last_name, :phone1, :phone2, :fax, :email,
                                                 :postal_address, :postal_address2, :city, :city2, :state, :state2,
                                                 :zip, :zip2, :date_of_formation, :m_date_of_formation,
                                                 :ein_or_ssn, :s_corp_status, :not_for_profit_status, :legal_ending,
                                                 :honorific, :is_honorific, :date_of_appointment, :m_date_of_appointment,
                                                 :country, :date_of_commission, :m_date_of_commission, :index,
                                                 :property_id)
  end

  def joint_tenant_params
    params.require(:joint_tenant).permit(:temp_id, :member_type_id, :name, :name2, :address, :type_, :jurisdiction, :number_of_assets,
                                         :first_name, :last_name, :phone1, :phone2, :fax, :email,
                                         :postal_address, :postal_address2, :city, :city2, :state, :state2, :zip, :zip2, :date_of_formation, :m_date_of_formation,
                                         :ein_or_ssn, :s_corp_status, :not_for_profit_status, :legal_ending, :honorific, :is_honorific,
                                         :date_of_appointment, :m_date_of_appointment, :country, :date_of_commission, :m_date_of_commission, :index, :country2, :part, :my_percentage, :contact_id)
  end

  def current_page
    @current_page = "entity"
  end

  def check_xhr_page
    unless request.xhr?
      if params[:action] != "basic_info"
        return redirect_to entities_joint_tenancy_basic_info_path(params[:entity_key], xhr: request.env["REQUEST_PATH"])
      end
    end
  end

  def set_entity
    key = params[:entity_key]
    @entity = Entity.find_by(key: key)
    if @entity.present?
      entity_check()
      @entity = EntityJointTenancy.find_by(key: key)
    end
  end

  def add_breadcrum
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">Clients </a></h4></div>".html_safe
    if params[:entity_key] and @entity.present? and !@entity.new_record?
      add_breadcrumb ("<div class=\"pull-left\"><h4><a href=\"#{edit_entity_path(@entity.key)}\">Edit Joint Tenancy: <span id='edit-title-jt'>#{@entity.name}</span></a><span id='int-action-jt'></span></h4></div>").html_safe
    else
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action] == "basic_info" ? "Add" : "" } Joint Tenancy </a></h4></div>".html_safe
    end

    if params[:action] != "basic_info"
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action].titleize}</a></h4></div>".html_safe
    end
  end

end
