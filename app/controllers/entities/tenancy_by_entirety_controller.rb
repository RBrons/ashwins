class Entities::TenancyByEntiretyController < ApplicationController
  before_action :current_page
  before_action :check_xhr_page
  before_action :set_entity, only: [:basic_info]
  before_action :add_breadcrum

  def basic_info
    #key = params[:entity_key]
    if request.get?
      #@entity = Entity.find_by(key: key)
      #if @entity.present?
      #  entity_check()
      #  @entity = EntityTenancyByEntirety.find_by(key: key)
      #end
      @entity       ||= EntityTenancyByEntirety.new(type_: params[:type])
      @just_created = params[:just_created].to_b
      add_breadcrumb "Clients", clients_path, :title => "Clients" 
      add_breadcrumb "Tenancy by the Entirety", '',  :title => "Tenancy by the Entirety"
      add_breadcrumb "Declare Property", '',  :title => "Declare Property"
    elsif request.post?
      @entity                 = EntityTenancyByEntirety.new(entity_tenancy_by_entirety_params)
      @entity.type_           = MemberType.getTenancyByTheEntiretyId
      @entity.basic_info_only = true
      @entity.user_id         = current_user.id

      if @entity.save
        AccessResource.add_access({ user: current_user, resource: Entity.find(@entity.id) })
        return render json: { redirect: view_context.entities_tenancy_by_entirety_basic_info_path(@entity.key), just_created: true }
      end
    elsif request.patch?
      #@entity                 = EntityTenancyByEntirety.find_by(key: key)
      @entity.type_           = MemberType.getTenancyByTheEntiretyId
      @entity.basic_info_only = true
      if @entity.update(entity_tenancy_by_entirety_params)
        return redirect_to edit_entity_path(@entity.key)
      end
    else
      raise UnknownRequestFormat
    end
    render layout: false if request.xhr?
  end

  def spouse
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @spouse                 = Spouse.find(id) if id.present?
      @spouse                 ||= Spouse.new
      @spouse.super_entity_id = @entity.id
      if request.get?
        add_breadcrumb "Clients", clients_path, :title => "Clients" 
        add_breadcrumb "Tenancy by the Entirety", '',  :title => "Tenancy by the Entirety"
        add_breadcrumb "Tenant by the Entirety", '',  :title => "Tenant by the Entirety"
        add_breadcrumb "Create", '',  :title => "Create"
    end
    if request.post?
      if @entity.spouses.count >= 2
        @spouses = @entity.spouses
        @entity.errors.add(:base, 'Cannot have more than two spouses!')
        return render layout: false, template: "entities/tenancy_by_entirety/spouses"
      end
      @spouse                 = Spouse.new(spouse_params)
      @spouse.super_entity_id = @entity.id
      @spouse.class_name      = "Spouse"
      @spouse.use_temp_id
      if @spouse.save
        @spouses = @spouse.super_entity.spouses
        return render layout: false, template: "entities/tenancy_by_entirety/spouses"
      else
        return render layout: false, template: "entities/tenancy_by_entirety/spouse"
      end
    elsif request.patch?
      if @spouse.update(spouse_params)
        @spouse.use_temp_id
        @spouses = @spouse.super_entity.spouses
        return render layout: false, template: "entities/tenancy_by_entirety/spouses"
      else
        return render layout: false, template: "entities/tenancy_by_entirety/spouse"
      end
    elsif request.delete?
      spouse = Spouse.find(params[:id])
      spouse.delete
      @entity  = spouse.super_entity
      @spouses = @entity.spouses
      return render layout: false, template: "entities/tenancy_by_entirety/spouses"
    end
    @spouse.gen_temp_id
    render layout: false if request.xhr?
  end

  def spouses
    @entity = Entity.find_by(key: params[:entity_key])
    raise ActiveRecord::RecordNotFound if @entity.blank?
    @spouses = @entity.spouses
    render layout: false if request.xhr?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  private
  def entity_tenancy_by_entirety_params
    params.require(:entity_tenancy_by_entirety).permit(:name, :name2, :address, 
                                                       :type_, :jurisdiction, 
                                                       :number_of_assets, :first_name, 
                                                       :last_name, :phone1, :phone2, 
                                                       :fax, :email, :postal_address, 
                                                       :postal_address2, :city, :city2, 
                                                       :state, :state2, :zip, :zip2, 
                                                       :date_of_formation, :m_date_of_formation,
                                                       :ein_or_ssn, :s_corp_status, 
                                                       :not_for_profit_status, :legal_ending, 
                                                       :honorific, :is_honorific,
                                                       :date_of_appointment, :m_date_of_appointment, 
                                                       :country, :date_of_commission, 
                                                       :m_date_of_commission, :index, :property_id)
  end

  def spouse_params
    params.require(:spouse).permit(:temp_id, :member_type_id, :name, :name2, 
                                   :address, :type_, :jurisdiction, :number_of_assets,
                                   :first_name, :last_name, :phone1, :phone2, :fax, 
                                   :email, :postal_address, :postal_address2, :city, 
                                   :city2, :state, :state2, :zip, :zip2, 
                                   :date_of_formation, :m_date_of_formation,
                                   :ein_or_ssn, :s_corp_status, :not_for_profit_status, 
                                   :legal_ending, :honorific, :is_honorific,
                                   :date_of_appointment, :m_date_of_appointment, 
                                   :country, :date_of_commission, :m_date_of_commission, 
                                   :index, :country2, :part, :my_percentage, :contact_id,
                                   :gender)
  end

  def current_page
    @current_page = "entity"
  end

  def check_xhr_page
    unless request.xhr?
      if params[:action] != "basic_info"
        return redirect_to entities_tenancy_by_entirety_basic_info_path(params[:entity_key], xhr: request.env["REQUEST_PATH"])
      end
    end
  end

  def set_entity
    key = params[:entity_key]
    @entity = Entity.find_by(key: key)
    if @entity.present?
      entity_check()
      @entity = EntityTenancyByEntirety.find_by(key: key)
    end
  end

  def add_breadcrum
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">Clients </a></h4></div>".html_safe
    if params[:entity_key] and @entity.present? and !@entity.new_record?
      add_breadcrumb ("<div class=\"pull-left\"><h4><a href=\"#{edit_entity_path(@entity.key)}\">Edit Tenancy By Entirety: <span id='edit-title-tbe'>#{@entity.name}</span></a><span id='int-action-tbe'></span></h4></div>").html_safe
    else
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action] == "basic_info" ? "Add" : "" } Tenancy By Entirety </a></h4></div>".html_safe
    end

    if params[:action] != "basic_info"
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action].titleize}</a></h4></div>".html_safe
    end
  end

end
