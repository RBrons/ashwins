class Entities::PowerOfAttorneyController < ApplicationController

  before_action :current_page
  before_action :check_xhr_page
  before_action :set_entity, only: [:basic_info]
  before_action :add_breadcrum

  def basic_info
    key = params[:entity_key]
    if request.get?
      @entity = Entity.find_by(key: key)
      entity_check() if @entity.present?
      @entity       ||= PowerOfAttorney.new(type_: params[:type])
      @just_created = params[:just_created].to_b
    elsif request.post?
      @entity                 = PowerOfAttorney.new(power_of_attorney_params)
      @entity.type_           = MemberType.getPowerOfAttorneyId
      @entity.basic_info_only = true
      @entity.user_id         = current_user.id
      @entity.name = @entity.first_name2 + ' ' + @entity.last_name2 + ' POA for ' +
        @entity.first_name + ' ' + @entity.last_name
      if @entity.save
        AccessResource.add_access({user: current_user, resource: Entity.find(@entity.id)})
        return render json: {redirect: view_context.entities_power_of_attorney_basic_info_path( @entity.key ), just_created: true}
        #return redirect_to clients_path
      end
    elsif request.patch?
      @entity                 = PowerOfAttorney.find_by(key: key)
      @entity.type_           = MemberType.getPowerOfAttorneyId
      @entity.basic_info_only = true
      @entity.assign_attributes(entity_params)
      @entity.name = @entity.first_name2 + ' ' + @entity.last_name2 + ' POA for ' +
        @entity.first_name + ' ' + @entity.last_name
      if @entity.save
        #redirect_to edit_entity_path(@entity.key)
      end
    else
      raise UnknownRequestFormat
    end
    render layout: false if request.xhr?
  end

  def principal
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key] || params[:key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?

      @principal                 = @entity.principales.first if @entity.principales.present?
      @principal                 ||= Principal.new
      @principal.super_entity_id = @entity.id
    end
    if request.post?
      @principal                 = Principal.new(principal_params)
      @principal.use_temp_id
      @principal.super_entity_id = @entity.id
      @principal.class_name      = "Principal"
      if @principal.save
        @principales = @principal.super_entity.principales
        return render layout: false, template: "entities/power_of_attorney/principals"
      else
        return render layout: false, template: "entities/power_of_attorney/principal"
      end
    elsif request.patch?
      if @principal.update(principal_params)
        @principal.use_temp_id
        @principales = @principal.super_entity.principales
        return render layout: false, template: "entities/power_of_attorney/principals"
      else
        return render layout: false, template: "entities/power_of_attorney/principal"
      end
    elsif request.delete?
      principal = Principal.find(params[:id])
      principal.delete
      @principales = principal.super_entity.principales
      return render layout: false, template: "entities/limited_partnership/principals"
    end
    @principal.gen_temp_id
    render layout: false if request.xhr?
  end

  def principals
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"#\">Principals </a></h4></div>".html_safe
    @entity = Entity.find_by(key: params[:entity_key])
    raise ActiveRecord::RecordNotFound if @entity.blank?
    @principales = @entity.principales
    render layout: false if request.xhr?
  end

  def agent
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"#\">Agent </a></h4></div>".html_safe
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key] || params[:key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?

      @agent                 = @entity.agents.first if @entity.agents.present?
      @agent                 ||= Agent.new
      @agent.super_entity_id = @entity.id
    end
    if request.post?
      @agent                 = Agent.new(agent_params)
      @agent.use_temp_id
      @agent.super_entity_id = @entity.id
      @agent.class_name      = "Agent"
      if @agent.save
        @agents             = @agent.super_entity.agents
        return render layout: false, template: "entities/power_of_attorney/agents"
      else
        return render layout: false, template: "entities/power_of_attorney/agent"
      end
    elsif request.patch?
      if @agent.update(agent_params)
        @agents             = @agent.super_entity.agents
        return render layout: false, template: "entities/power_of_attorney/agents"
      else
        return render layout: false, template: "entities/power_of_attorney/agent"
      end
    elsif request.delete?
      agent = Agent.find(params[:id])
      agent.delete
      @entity = Entity.find_by(key: agent.super_entity.key)
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @agents = @entity.agents
      return render layout: false, template: "entities/power_of_attorney/agents"
    end
    @agent.gen_temp_id
    render layout: false if request.xhr?
  end

  def agents
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"#\">Agents </a></h4></div>".html_safe
    @entity = Entity.find_by(key: params[:entity_key])
    raise ActiveRecord::RecordNotFound if @entity.blank?
    @agents = @entity.agents
    render layout: false if request.xhr?
  end

  def owns
    @entity = Entity.find_by(key: params[:entity_key])
    raise ActiveRecord::RecordNotFound if @entity.blank?
    render layout: false if request.xhr?
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  private
  def power_of_attorney_params
    params.require(:power_of_attorney).permit(:name, :name2, :address, :type_, :jurisdiction, :number_of_assets,
                                              :first_name, :last_name, :first_name2, :last_name2, :phone1, :phone2, :fax, :email,
                                              :postal_address, :postal_address2, :city, :city2, :state, :state2, :zip, :zip2, :date_of_formation, :m_date_of_formation,
                                              :ein_or_ssn, :s_corp_status, :not_for_profit_status, :legal_ending, :honorific, :is_honorific,
                                              :date_of_appointment, :m_date_of_appointment, :country, :date_of_commission, :m_date_of_commission, :index, :county)
  end

  def entity_params
    params.require(:entity).permit(:name, :name2, :address, :type_, :jurisdiction, :number_of_assets,
                                   :first_name, :last_name, :first_name2, :last_name2, :phone1, :phone2, :fax, :email,
                                   :postal_address, :postal_address2, :city, :city2, :state, :state2, :zip, :zip2, :date_of_formation, :m_date_of_formation,
                                   :ein_or_ssn, :s_corp_status, :not_for_profit_status, :legal_ending, :honorific, :is_honorific,
                                   :date_of_appointment, :m_date_of_appointment, :country, :date_of_commission, :m_date_of_commission, :index, :county)
  end

  def principal_params
    params.require(:principal).permit(:temp_id, :member_type_id, :is_person, :entity_id, :first_name, :last_name, :phone1, :phone2,
                                      :fax, :email, :postal_address, :city, :state, :zip, :ein_or_ssn,
                                      :stock_share, :notes, :honorific, :is_honorific, :my_percentage, :tax_member, :contact_id)
  end


  def agent_params
    params.require(:agent).permit(:temp_id, :member_type_id, :is_person, :entity_id, :first_name, :last_name, :phone1, :phone2,
                                  :fax, :email, :postal_address, :city, :state, :zip, :ein_or_ssn,
                                  :stock_share, :notes, :honorific, :is_honorific, :my_percentage, :tax_member, :contact_id)
  end

  def current_page
    @current_page = "entity"
  end

  def check_xhr_page
    unless request.xhr?
      if params[:action] != "basic_info"
        return redirect_to entities_power_of_attorney_basic_info_path(params[:entity_key], xhr: request.env["REQUEST_PATH"])
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
     add_breadcrumb ("<div class=\"pull-left\"><h4><a href=\"#{edit_entity_path(@entity.key)}\">Edit Power of Attorney: <span id='edit-title-poa'>#{@entity.name}</span></a><span id='int-action-poa'></span></h4></div>").html_safe
    else
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action] == "basic_info" ? "Add" : "" } Power of Attorney </a></h4></div>".html_safe
    end

    #if params[:action] != "basic_info"
    #  add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action].titleize}</a></h4></div>".html_safe
    #end
  end

end
