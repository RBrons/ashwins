class Entities::LlcController < ApplicationController

  before_action :current_page
  # before_action :check_xhr_page
  before_action :set_entity, only: [:basic_info]
  before_action :add_breadcrum

  def basic_info
    #key = params[:entity_key]
    if request.get?
      #@entity = Entity.find_by(key: key)
      entity_check() if @entity.present?
      @entity       ||= Entity.new(type_: params[:type])
      @just_created = params[:just_created].to_b
    elsif request.post?
      @entity                 = Entity.new(entity_params)
      @entity.type_           = MemberType.getLLCId
      @entity.basic_info_only = true
      @entity.user_id         = current_user.id

      if @entity.save
        AccessResource.add_access({ user: current_user, resource: @entity })
        flash[:success] = "New Client Successfully Created.</br><a href='#{clients_path(active_id: @entity.id)}'>Show in List</a>"
        return redirect_to entities_llc_basic_info_path( @entity.key )
        # return render json: {redirect: view_context.entities_llc_basic_info_path( @entity.key ), just_created: true}
        #return redirect_to clients_path
      end
    elsif request.patch?
      #@entity                 = Entity.find_by(key: key)
      @entity.type_           = MemberType.getLLCId
      @entity.basic_info_only = true
      if @entity.update(entity_params)
        #return redirect_to edit_entity_path(@entity.key)
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
    elsif request.patch?
      @entity.basic_info_only = false
      @entity.update(entity_params)
      return render layout: false, template: "entities/llc/contact_info"
    else
      raise UnknownRequestFormat
    end
    render layout: false if request.xhr?
  end

  def manager
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @manager                 = Manager.find(id) if id.present?
      @manager                 ||= Manager.new
      @manager.super_entity_id = @entity.id
    end
    if request.post?
      @manager                 = Manager.new(manager_params)
      @manager.super_entity_id = @entity.id
      @manager.class_name      = "Manager"
      @manager.use_temp_id
      if @manager.save
        @managers = @manager.super_entity.managers + @manager.super_entity.members.where(is_manager: true)
        flash[:success] = "New Manager Successfully Created.</br><a href='#{entities_llc_managers_path( @entity.key, active_id: @manager.id )}'>Show in List</a>"
        return redirect_to entities_llc_manager_path( @entity.key, @manager.id )
        # return render layout: false, template: "entities/llc/managers"
      else
        return render layout: false, template: "entities/llc/manager"
      end
    elsif request.patch?
      if @manager.update(manager_params)
        @manager.use_temp_id
        @manager.save
        @managers = @manager.super_entity.managers + @manager.super_entity.members.where(is_manager: true)
        # return render layout: false, template: "entities/llc/managers"
        flash[:success] = "The Manager Successfully updated.</br><a href='#{entities_llc_managers_path( @entity.key )}'>Show in List</a>"
        return redirect_to entities_llc_manager_path( @entity.key, @manager.id )
      else
        # return render layout: false, template: "entities/llc/manager"
        return redirect_to entities_llc_manager_path( @entity.key, @manager.id )
      end
    elsif request.delete?
      manager = Manager.find(params[:id])
      @entity   = manager.super_entity
      @managers = @entity.managers + @entity.members.where(is_manager: true)
      manager.delete
      # return render layout: false, template: "entities/llc/managers"
      flash[:success] = "The Manager Successfully Deleted."
      return redirect_to entities_llc_managers_path( @entity.key )
    end
    @manager.gen_temp_id
    render layout: false if request.xhr?
  end

  def managers
    @entity = Entity.find_by(key: params[:entity_key])
    raise ActiveRecord::RecordNotFound if @entity.blank?
    @managers = @entity.managers + @entity.members.where(is_manager: true)
    @activeId = params[:active_id]
    render layout: false if request.xhr?
  end

  def member
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @member                 = Member.find(id) if id.present?
      @member                 ||= Member.new
      @member.super_entity_id = @entity.id
      @member.class_name      = "Member"
    end
    if request.post?
      @member                 = Member.new(member_params)
      @member.super_entity_id = @entity.id
      @member.class_name      = "Member"
      @member.use_temp_id
      if @member.save
        @members = @entity.members #.where(is_manager: false)
        flash[:success] = "New Member Successfully Created.</br><a href='#{entities_llc_members_path( @entity.key, active_id: @member.id )}'>Show in List</a>"
        return redirect_to entities_llc_member_path( @entity.key, @member.id )
      else
        return redirect_to entities_llc_member_path( @entity.key, @member.id )
      end
    elsif request.patch?
      if @member.update(member_params)
        @member.use_temp_id
        @member.save
        @members = @entity.members #.where(is_manager: false)
        # return render layout: false, template: "entities/llc/members"
        flash[:success] = "The Member Successfully updated.</br><a href='#{entities_llc_members_path( @entity.key, active_id: @member.id )}'>Show in List</a>"
        return redirect_to entities_llc_member_path( @entity.key, @member.id )
      else
        # return render layout: false, template: "entities/llc/member"
        return redirect_to entities_llc_member_path( @entity.key, @member.id )
      end
    elsif request.delete?
      member = Member.find(params[:id])
      @entity = Entity.find_by(key: member.super_entity.key)
      raise ActiveRecord::RecordNotFound if @entity.blank?
      member.delete
      @members = @entity.members #.where(is_manager: false)
      # return render layout: false, template: "entities/llc/members"
      flash[:success] = "The Member Successfully Deleted."
      return redirect_to entities_llc_members_path( @entity.key )
    end
    @member.gen_temp_id
    render layout: false if request.xhr?
  end

  def members(entity_key = params[:entity_key])
    @entity = Entity.find_by(key: entity_key)
    raise ActiveRecord::RecordNotFound if @entity.blank?
    @members = @entity.members #.where(is_manager: false)
    @activeId = params[:active_id]
    render layout: false if request.xhr?
  end

  def owns
    @entity = Entity.find_by(key: params[:entity_key])
    @ownership_ = @entity.build_ownership_tree_json
    @owns_available = (@ownership_[0][:nodes] == nil) ? false : true
    @ownership = @ownership_.to_json
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
                                   :is_honorific, :has_comma, :legal_ending)
  end

  def member_params
    params.require(:member).permit(:temp_id, :member_type_id, :is_person, :entity_id, :first_name, :last_name, :phone1, :phone2,
                                   :fax, :email, :postal_address, :city, :state, :zip, :ein_or_ssn,
                                   :my_percentage, :notes, :honorific, :is_honorific, :tax_member,
                                   :legal_ending, :has_comma, :contact_id, :is_manager)
  end

  def manager_params
    params.require(:manager).permit(:temp_id, :member_type_id, :is_person, :entity_id, :first_name, :last_name, :phone1, :phone2,
                                    :fax, :email, :postal_address, :city, :state, :zip, :ein_or_ssn,
                                    :my_percentage, :notes, :honorific, :is_honorific, :legal_ending,
                                    :has_comma, :contact_id)
  end

  def current_page
    @current_page = "entity"
  end

  def check_xhr_page
    unless request.xhr?
      if params[:action] != "basic_info"
        return redirect_to entities_llc_basic_info_path(params[:entity_key], xhr: request.env["REQUEST_PATH"])
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
      add_breadcrumb ("<div class=\"pull-left\"><h4><a href=\"#{edit_entity_path(@entity.key)}\">Edit LLC: <span id='edit-title-llc'>#{@entity.display_name}</span></a><span id='int-action-llc'></span></h4></div>").html_safe
    else
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action] == "basic_info" ? "Add" : "" } LLC </a></h4></div>".html_safe
    end

    if params[:action] != "basic_info"
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action].titleize}</a></h4></div>".html_safe
    end
  end

end
