class Entities::JointTenancyController < ApplicationController

  before_action :current_page
  before_action :check_xhr_page
  before_action :set_entity, only: [:basic_info]
  # before_action :add_breadcrum

  def basic_info
    #key = params[:entity_key]
    if request.get?
      #@entity = Entity.find_by(key: key)
      #if @entity.present?
      #  entity_check()
      #  @entity = EntityJointTenancy.find_by(key: key)
      #end
      @entity       ||= EntityJointTenancy.new(type_: params[:type])
      @just_created = params[:just_created].to_b
      add_breadcrumb "Clients", clients_path, :title => "Clients" 
      add_breadcrumb "Joint Tenancy", '',  :title => "Joint Tenancy"
      # add_breadcrumb "Joint Tenant", '',  :title => "Joint Tenant"
      add_breadcrumb "Declare Property", '',  :title => "Declare Property"
    elsif request.post?
      @entity                 = EntityJointTenancy.new(entity_joint_tenancy_params)
      @entity.type_           = MemberType.getJointTenancyId
      @entity.basic_info_only = true
      @entity.user_id         = current_user.id

      if @entity.save
        AccessResource.add_access({ user: current_user, resource: Entity.find(@entity.id) })
        return render json: { redirect: view_context.entities_joint_tenancy_basic_info_path(@entity.key), just_created: true }
      end
    elsif request.patch?
      #@entity                 = EntityJointTenancy.find_by(key: key)
      @entity.type_           = MemberType.getJointTenancyId
      @entity.basic_info_only = true
      if @entity.update(entity_joint_tenancy_params)
        return redirect_to edit_entity_path(@entity.key)
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
        add_breadcrumb "Clients", clients_path, :title => "Clients" 
        add_breadcrumb "Joint Tenancy", '',  :title => "Joint Tenancy"
        add_breadcrumb "Joint Tenant", '',  :title => "Joint Tenant"
        add_breadcrumb "Declare Property", '',  :title => "Declare Property"
      end
    end
    if request.post?
      @joint_tenant                 = JointTenant.new(joint_tenant_params)
      @joint_tenant.super_entity_id = @entity.id
      @joint_tenant.class_name      = "JointTenant"
      @joint_tenant.use_temp_id
      if @joint_tenant.save
        @joint_tenants = @joint_tenant.super_entity.joint_tenants
        return render layout: false, template: "entities/joint_tenancy/joint_tenants"
      else
        return render layout: false, template: "entities/joint_tenancy/joint_tenant"
      end
    elsif request.patch?
      if @joint_tenant.update(joint_tenant_params)
        @joint_tenant.use_temp_id
        @joint_tenants = @joint_tenant.super_entity.joint_tenants
        return render layout: false, template: "entities/joint_tenancy/joint_tenants"
      else
        return render layout: false, template: "entities/joint_tenancy/joint_tenant"
      end
    elsif request.delete?
      joint_tenant = JointTenant.find(params[:id])
      joint_tenant.delete
      @entity        = joint_tenant.super_entity
      @joint_tenants = @entity.joint_tenants
      return render layout: false, template: "entities/joint_tenancy/joint_tenants"
    end
    @joint_tenant.gen_temp_id
    render layout: false if request.xhr?
  end

  def joint_tenants
    @entity = Entity.find_by(key: params[:entity_key])
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
