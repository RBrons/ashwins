class Entities::SoleProprietorshipController < ApplicationController

  before_action :current_page
  before_action :check_xhr_page
  before_action :set_entity, only: [:basic_info]
  # before_action :add_breadcrum

  def basic_info
    #key = params[:entity_key]
    if request.get?
      #@entity = Entity.find_by(key: key)
      entity_check() if @entity.present?
      @entity       ||= Entity.new(type_: params[:type])
      @just_created = params[:just_created].to_b
      if @entity.name == ""
        add_breadcrumb "/Clients/", clients_path, :title => "Clients" 
        add_breadcrumb " Sole Proprietorship/", '',  :title => "Sole proprietorship"
        add_breadcrumb " Create", '',  :title => "Create"
      else
        add_breadcrumb "/Clients/", clients_path, :title => "Clients" 
        add_breadcrumb " Sole Proprietorship/", '',  :title => "Sole Proprietorship"
        add_breadcrumb " Edit: #{@entity.name}", '',  :title => "edit"
        add_breadcrumb "Show in list", clients_path(active_id: @entity.id), :title => "show", :id => "show_in_list"
      end
    elsif request.post?
      @entity                 = Entity.new(entity_params)
      @entity.type_           = MemberType.getSoleProprietorshipId
      @entity.basic_info_only = true
      @entity.user_id         = current_user.id
      @entity.name = @entity.name2
      if !@entity.name || @entity.name.blank?
        @entity.name = @entity.first_name + ' ' + @entity.last_name
      end
      if @entity.save
        AccessResource.add_access({user: current_user, resource: @entity})
        #return render json: {redirect: view_context.entities_sole_proprietorship_basic_info_path( @entity.key ), just_created: true}
        # flash[:success] = "New Client Successfully Created.</br><a href='#{clients_path(active_id: @entity.id)}'>Show in List</a>"
        return redirect_to entities_sole_proprietorship_basic_info_path( @entity.key )
      end
    elsif request.patch?
      #@entity                 = Entity.find_by(key: key)
      @entity.type_           = MemberType.getSoleProprietorshipId
      @entity.basic_info_only = true
      @entity.assign_attributes(entity_params)
      @entity.name = @entity.name2
      if !@entity.name || @entity.name.blank?
        @entity.name = @entity.first_name + ' ' + @entity.last_name
      end
      if @entity.save(entity_params)
        flash[:success] = "This Client Successfully Updated.</br><a href='#{clients_path(active_id: @entity.id)}'>Show in List</a>"
        return redirect_to entities_sole_proprietorship_basic_info_path( @entity.key )
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
      #TODO0
      add_breadcrumb "/Clients/", clients_path, :title => "Clients" 
      add_breadcrumb " Sole Proprietorship/", '',  :title => "Sole Proprietorship"
      add_breadcrumb " Edit: #{@entity.name}/", '',  :title => "edit"
      add_breadcrumb " Contact info", '', :title => "Contact info"
      add_breadcrumb "Show in list", clients_path(active_id: @entity.id), :title => "show", :id => "show_in_list" 
    elsif request.patch?
      @entity.basic_info_only = false
      @entity.update(entity_params)
      add_breadcrumb "/Clients/", clients_path, :title => "Clients" 
      add_breadcrumb " Sole Proprietorship/", '',  :title => "Sole Proprietorship"
      add_breadcrumb " Edit: #{@entity.name}/", '',  :title => "edit"
      add_breadcrumb " Contact info", '', :title => "Contact info"
      add_breadcrumb "Show in list", clients_path(active_id: @entity.id), :title => "show", :id => "show_in_list"
      return render layout: false, template: "entities/sole_proprietorship/contact_info"
    else
      raise UnknownRequestFormat
    end
    render layout: false if request.xhr?
  end

  def owns
    @entity = Entity.find_by(key: params[:entity_key])
    @ownership_ = @entity.build_ownership_tree_json
    @owns_available = (@ownership_[0][:nodes] == nil) ? false : true
    @ownership = @ownership_.to_json
    add_breadcrumb "/Clients/", clients_path, :title => "Clients" 
    add_breadcrumb " Sole Proprietorship/", '',  :title => "Sole Proprietorship"
    add_breadcrumb " Owns", '',  :title => "Owns"
    add_breadcrumb "Show in list", clients_path(active_id: @entity.id), :title => "show", :id => "show_in_list_own"
    raise ActiveRecord::RecordNotFound if @entity.blank?
    render layout: false if request.xhr?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  private
  def entity_params
    params.require(:entity).permit(:name, :name2, :address, :type_, :jurisdiction, :number_of_assets,
                                   :first_name, :last_name, :phone1, :phone2, :fax, :email,
                                   :postal_address, :postal_address2, :city, :city2, :state, :state2, :zip, :zip2, :date_of_formation, :m_date_of_formation,
                                   :ein_or_ssn, :s_corp_status, :not_for_profit_status, :legal_ending, :honorific, :is_honorific)
  end

  def current_page
    @current_page = "entity"
  end

  def check_xhr_page
    unless request.xhr?
      if params[:action] != "basic_info"
        return redirect_to entities_limited_partnership_basic_info_path(params[:entity_key], xhr: request.env["REQUEST_PATH"])
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
      add_breadcrumb ("<div class=\"pull-left\"><h4><a href=\"#{edit_entity_path(@entity.key)}\">Edit Sole Proprietorship: #{@entity.name}</a><span id='int-action-soleprop'></span></h4></div>").html_safe
    else
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action] == "basic_info" ? "Add" : "" } Sole Proprietorship </a></h4></div>".html_safe
    end

    if params[:action] != "basic_info"
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action].titleize}</a></h4></div>".html_safe
    end
  end

end
