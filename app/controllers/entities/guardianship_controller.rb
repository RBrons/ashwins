class Entities::GuardianshipController < ApplicationController

  before_action :current_page
  before_action :check_xhr_page
  before_action :set_entity, only: [:basic_info, :guardian, :judge]
  before_action :add_breadcrum

  def basic_info
    #key = params[:entity_key]
    if request.get?
      #@entity = Entity.find_by(key: key)
      #if @entity.present?
      #  entity_check()
      #  @entity = EntityGuardianship.find_by(key: key)
      #end
      @entity       ||= EntityGuardianship.new(type_: params[:type])
      @just_created = params[:just_created].to_b
    elsif request.post?
      @entity                 = EntityGuardianship.new(entity_guardianship_params)
      @entity.type_           = MemberType.getGuardianshipId
      @entity.basic_info_only = true
      @entity.user_id         = current_user.id
      @entity.name = "In re " + @entity.first_name + " " + @entity.last_name + ", AIP"
      if @entity.save
        AccessResource.add_access({user: current_user, resource: Entity.find(@entity.id)})
        return render json: {redirect: view_context.entities_guardianship_basic_info_path( @entity.key ), just_created: true}
        #return redirect_to clients_path
      end
    elsif request.patch?
      #@entity                 = EntityGuardianship.find_by(key: key)
      @entity.type_           = MemberType.getGuardianshipId
      @entity.basic_info_only = true
      @entity.assign_attributes(entity_guardianship_params)
      @entity.name = "In re " + @entity.first_name + " " + @entity.last_name + ", AIP"
      if @entity.save
       #return redirect_to edit_entity_path(@entity.key)
      end
    else
      raise UnknownRequestFormat
    end
    render layout: false if request.xhr?
  end

  def judge
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"#\">Judge </a></h4></div>".html_safe
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @judge                 = Judge.find(id) if id.present?
      @judge                 ||= Judge.new
      @judge.super_entity_id = @entity.id
      @judge.class_name      = "Judge"
    end
    if request.post?
      @judge                 = Judge.new(judge_params)
      @judge.use_temp_id
      @judge.super_entity_id = @entity.id
      @judge.class_name      = "Judge"
      if @judge.save
        @judge = @entity.judge
        return render layout: false, template: "entities/guardianship/judge"
      else
        @judge = @entity.judge
        return render layout: false, template: "entities/guardianship/judge"
      end
    elsif request.patch?
      @judge.assign_attributes(judge_params)
      @judge.use_temp_id
      if @judge.save
        @judge = @entity.judge
        return render layout: false, template: "entities/guardianship/judge"
      else
        @judge = @entity.judge
        return render layout: false, template: "entities/guardianship/judge"
      end
    elsif request.delete?
      judge = Judge.find(params[:id])
      judge.delete
      @entity = Entity.find_by(key: judge.super_entity.key)
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @judge = @entity.judge
      return render layout: false, template: "entities/guardianship/judge"
    end
    @judge.gen_temp_id
    render layout: false if request.xhr?
  end

  def guardian
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"#\">Guardian </a></h4></div>".html_safe
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @guardian                 = Guardian.find(id) if id.present?
      @guardian                 ||= Guardian.new
      @guardian.super_entity_id = @entity.id
      @guardian.class_name      = "Guardian"
    end
    if request.post?
      @guardian                 = Guardian.new(guardian_params)
      @guardian.use_temp_id
      @guardian.super_entity_id = @entity.id
      @guardian.class_name      = "Guardian"
      if @guardian.save
        @guardian = @entity.guardian
        return render layout: false, template: "entities/guardianship/guardian"
      else
        @guardian = @entity.guardian
        return render layout: false, template: "entities/guardianship/guardian"
      end
    elsif request.patch?
      @guardian.assign_attributes(guardian_params)
      @guardian.use_temp_id
      if @guardian.save
        @guardian = @entity.guardian
        return render layout: false, template: "entities/guardianship/guardian"
      else
        @guardian = @entity.guardian
        return render layout: false, template: "entities/guardianship/guardian"
      end
    elsif request.delete?
      guardian = Guardian.find(params[:id])
      guardian.delete
      @entity = Entity.find_by(key: guardian.super_entity.key)
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @guardian = @entity.guardian
      return render layout: false, template: "entities/guardianship/guardian"
    end
    @guardian.gen_temp_id
    render layout: false if request.xhr?
  end

  def ward
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"#\">Ward </a></h4></div>".html_safe
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @ward                 = Ward.find(id) if id.present?
      @ward                 ||= Ward.new
      @ward.super_entity_id = @entity.id
      @ward.class_name      = "Ward"
    end
    if request.post?
      @ward                 = Ward.new(ward_params)
      @ward.use_temp_id
      @ward.super_entity_id = @entity.id
      @ward.class_name      = "Ward"
      if @ward.save
        @ward = @entity.ward
        return render layout: false, template: "entities/guardianship/ward"
      else
        @ward = @entity.ward
        return render layout: false, template: "entities/guardianship/ward"
      end
    elsif request.patch?
      @ward.assign_attributes(ward_params)
      @ward.use_temp_id
      if @ward.save
        @ward = @entity.ward
        return render layout: false, template: "entities/guardianship/ward"
      else
        @ward = @entity.ward
        return render layout: false, template: "entities/guardianship/ward"
      end
    elsif request.delete?
      ward = Ward.find(params[:id])
      ward.delete
      @entity = Entity.find_by(key: ward.super_entity.key)
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @ward = @entity.ward
      return render layout: false, template: "entities/guardianship/ward"
    end
    @ward.gen_temp_id
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
  def entity_guardianship_params
    params.require(:entity_guardianship).permit(:name, :name2, :address, :type_, :jurisdiction, :number_of_assets,
                                                :first_name, :last_name, :phone1, :phone2, :fax, :email,
                                                :postal_address, :postal_address2, :city, :city2, :state, :state2,
                                                :zip, :zip2, :date_of_formation, :m_date_of_formation,
                                                :ein_or_ssn, :s_corp_status, :not_for_profit_status, :legal_ending,
                                                :honorific, :is_honorific, :date_of_appointment, :m_date_of_appointment,
                                                :country, :date_of_commission, :m_date_of_commission, :index,
                                                :county, :judge_first_name, :judge_last_name, :guardian_first_name,
                                                :guardian_last_name)
  end

  def judge_params
    params.require(:judge).permit(:temp_id, :member_type_id, :is_person, :entity_id, :first_name, :last_name, :phone1, :phone2, :fax, :email, :postal_address, :city, :state, :zip, :ein_or_ssn, :my_percentage, :notes, :honorific, :is_honorific, :contact_id)
  end

  def guardian_params
    params.require(:guardian).permit(:temp_id, :member_type_id, :is_person, :entity_id, :first_name, :last_name, :phone1, :phone2, :fax, :email, :postal_address, :city, :state, :zip, :ein_or_ssn, :my_percentage, :notes, :honorific, :is_honorific, :contact_id)
  end

  def ward_params
    params.require(:ward).permit(:temp_id, :member_type_id, :is_person, :entity_id, :first_name, :last_name, :phone1, :phone2, :fax, :email, :postal_address, :city, :state, :zip, :ein_or_ssn, :my_percentage, :notes, :honorific, :is_honorific, :contact_id)
  end

  def entity_params
    params.require(:entity).permit(:name, :name2, :address, :type_, :jurisdiction, :number_of_assets,
                                   :first_name, :last_name, :phone1, :phone2, :fax, :email,
                                   :postal_address, :postal_address2, :city, :city2, :state, :state2, :zip, :zip2,
                                   :date_of_formation, :m_date_of_formation, :ein_or_ssn, :s_corp_status,
                                   :not_for_profit_status, :legal_ending, :honorific, :is_honorific,
                                   :date_of_appointment, :m_date_of_appointment, :country, :date_of_commission,
                                   :m_date_of_commission, :index, :country2, :part, :county, :judge_first_name,
                                   :judge_last_name, :guardian_first_name, :guardian_last_name)
  end

  def current_page
    @current_page = "entity"
  end

  def check_xhr_page
    unless request.xhr?
      if params[:action] != "basic_info"
        return redirect_to entities_guardianship_basic_info_path(params[:entity_key], xhr: request.env["REQUEST_PATH"])
      end
    end
  end

  def set_entity
    key = params[:entity_key]
    @entity = Entity.find_by(key: key)
    if @entity.present?
      entity_check()
      @entity = EntityGuardianship.find_by(key: key)
    end
  end

  def add_breadcrum
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">Clients </a></h4></div>".html_safe
    if params[:entity_key] and @entity.present? and !@entity.new_record?
      add_breadcrumb ("<div class=\"pull-left\"><h4><a href=\"#{edit_entity_path(@entity.key)}\">Edit Guardianship: <span id='edit-title-g'>#{@entity.name}</span></a><span id='int-action-gdship'></span></h4></div>").html_safe
    else
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action] == "basic_info" ? "Add" : "" } Guardianship </a></h4></div>".html_safe
    end

    if params[:action] != "basic_info"
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action].titleize}</a></h4></div>".html_safe
    end
  end

end
