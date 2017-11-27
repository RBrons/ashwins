class Entities::PartnershipController < ApplicationController

  layout "entities"

  before_action :current_page
  before_action :check_xhr_page, only: [:contact_info, :owns]
  before_action :set_entity, only: [:basic_info]
  
  def basic_info
    #key = params[:entity_key]
    if request.get?
      #@entity = Entity.find_by(key: key)
      entity_check() if @entity.present?
      @entity       ||= Entity.new(type_: params[:type])
      if @entity.new_record?
        add_breadcrumb "Clients", clients_path, :title => "Clients"
        add_breadcrumb "Partnership", '',  :title => "Partnership"
        add_breadcrumb "Create", '',  :title => "Create"
      else
        add_breadcrumb "Clients", clients_path, :title => "Clients"
        add_breadcrumb "Partnership", '',  :title => "Partnership"
        add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
        add_breadcrumb "Basic info", '', :title => "Basic info"
      end
    elsif request.post?
      @entity                 = Entity.new(entity_params)
      @entity.type_           = MemberType.getPartnershipId
      @entity.basic_info_only = true
      @entity.user_id         = current_user.id

      if @entity.save
        AccessResource.add_access({ user: current_user, resource: @entity })
        flash[:success] = "Congratulations, you have just created a record for #{@entity.display_name}"
        return redirect_to entities_partnership_basic_info_path( @entity.key )
      else
        return redirect_to entities_partnership_basic_info_path( @entity.key )
      end
    elsif request.patch?
      #@entity                 = Entity.find_by(key: key)
      prior_entity_name = @entity.display_name
      @entity.type_           = MemberType.getPartnershipId
      @entity.basic_info_only = true
      if @entity.update(entity_params)
        flash[:success] = "Congratulations, you have just made a change in the record for #{prior_entity_name}"
        return redirect_to entities_partnership_basic_info_path( @entity.key )
      end
    else
      raise UnknownRequestFormat
    end
    render layout: false if request.xhr?
  end

  def contact_info
    @entity = Entity.find_by(key: params[:entity_key])
    raise ActiveRecord::RecordNotFound if @entity.blank?
    if request.get?
      #TODO
      add_breadcrumb "Clients", clients_path, :title => "Clients"
      add_breadcrumb "Partnership", '',  :title => "Partnership"
      add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "edit"
      add_breadcrumb "Contact info", '', :title => "Contact info"
    elsif request.patch?
      @entity.basic_info_only = false
      @entity.update(entity_params)
      add_breadcrumb "Clients", clients_path, :title => "Clients"
      add_breadcrumb "Partnership", '',  :title => "Partnership"
      add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "edit"
      add_breadcrumb "Contact info", '', :title => "Contact info"
      
      return render layout: false, template: "entities/partnership/contact_info"
    else
      raise UnknownRequestFormat
    end
    render layout: false if request.xhr?
  end

  def partner
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @partner                 = Partner.find(id) if id.present?
      @partner                 ||= Partner.new
      @partner.super_entity_id = @entity.id
      @partner.class_name      = "Partner"

      if request.get?
        if @partner.new_record?
          add_breadcrumb "Clients", clients_path, :title => "Clients"
          add_breadcrumb "Partnership", '',  :title => "Partnership"
          add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
          add_breadcrumb "Partner Create", '',  :title => "Partner Create"
        else
          add_breadcrumb "Clients", clients_path, :title => "Clients"
          add_breadcrumb "Partnership", '',  :title => "Partnership"
          add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
          add_breadcrumb "Partner", '',  :title => "Partner"
        end
      end
    end
    if request.post?
      @partner                 = Partner.new(partner_params)
      @partner.use_temp_id
      @partner.super_entity_id = @entity.id
      @partner.class_name      = "Partner"
      if @partner.save
        @partners = @partner.super_entity.partners
        flash[:success] = "Congratulations, you have just created a record for #{@partner.first_name} #{@partner.last_name}, a Partner of #{@entity.display_name}"
        return redirect_to entities_partnership_partners_path(@entity.key)
      else
        return redirect_to entities_partnership_partner_path(@entity.key)
      end
    elsif request.patch?
      prior_partner_name = "#{@partner.first_name} #{@partner.last_name}"
      if @partner.update(partner_params)
        @partner.use_temp_id
        @partner.save
        @partners = @partner.super_entity.partners
        flash[:success] = "Congratulations, you have just made a change in the record for #{prior_partner_name}, a Partner of #{@entity.display_name}"
        return redirect_to entities_partnership_partners_path(@entity.key)
      else
        return redirect_to entities_partnership_partner_path(@entity.key, @partner.id)
      end
    elsif request.delete?
      partner = Partner.find(params[:id])
      @entity = partner.super_entity
      partner.delete
      @partners = partner.super_entity.partners
      return redirect_to entities_partnership_partners_path(@entity.key)
    end
    @partner.gen_temp_id
    render layout: false if request.xhr?
  end

  def partners
    @entity = Entity.find_by(key: params[:entity_key])
    add_breadcrumb "Clients", clients_path, :title => "Clients"
    add_breadcrumb "Partnership", '',  :title => "Partnership"    
    add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
    add_breadcrumb "Partners List View", '',  :title => "Partners List View"
    
    raise ActiveRecord::RecordNotFound if @entity.blank?
    @partners = @entity.partners
    render layout: false if request.xhr?
  end

  def owns
    @entity = Entity.find_by(key: params[:entity_key])
    @ownership_ = @entity.build_ownership_tree_json
    @owns_available = (@ownership_[0][:nodes] == nil) ? false : true
    @ownership = @ownership_.to_json
    add_breadcrumb "Clients", clients_path, :title => "Clients"
    add_breadcrumb "Partnership", '',  :title => "Partnership"
    add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
    add_breadcrumb "Owns", '',  :title => "Owns"
    
    raise ActiveRecord::RecordNotFound if @entity.blank?
    render layout: false if request.xhr?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  private
  def entity_params
    params.require(:entity).permit(:name, :address, :type_, :jurisdiction, :number_of_assets,
                                   :first_name, :last_name, :phone1, :phone2, :fax, :email,
                                   :postal_address, :city, :state, :zip, :date_of_formation,
                                   :m_date_of_formation, :ein_or_ssn, :s_corp_status,
                                   :not_for_profit_status, :legal_ending, :honorific,
                                   :is_honorific, :legal_ending, :has_comma)
  end

  def partner_params
    params.require(:partner).permit(:temp_id, :member_type_id, :is_person, :entity_id, :first_name, :last_name, :phone1, :phone2,
                                    :fax, :email, :postal_address, :city, :state, :zip, :ein_or_ssn,
                                    :my_percentage, :notes, :honorific, :is_honorific, :tax_member,
                                    :legal_ending, :has_comma, :contact_id)
  end

  def current_page
    @current_page = "entity"
  end

  def check_xhr_page
    unless request.xhr?
      if params[:action] != "basic_info"
        return redirect_to entities_partnership_basic_info_path(params[:entity_key], xhr: request.env["REQUEST_PATH"])
      end
    end
  end

  def set_entity
    key = params[:entity_key]
    @entity = Entity.find_by(key: key)
  end

  def add_breadcrum
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">Clients </a></h4></div>".html_safe
    if params[:entity_key] and @entity.present? and !@entity.new_record?
      add_breadcrumb ("<div class=\"pull-left\"><h4><a href=\"#{edit_entity_path(@entity.key)}\">Edit Partnership: <span id='edit-title-pship'>#{@entity.display_name}</span></a><span id='int-action-pship'></span></h4></div>").html_safe
    else
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action] == "basic_info" ? "Add" : "" } Partnership </a></h4></div>".html_safe
    end

    if params[:action] != "basic_info"
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action].titleize}</a></h4></div>".html_safe
    end
  end

end
