class Entities::CorporatesController < ApplicationController

  layout "entities"

  before_action :current_page
  # before_action :check_xhr_page
  before_action :set_entity, only: [:basic_info]
  # before_action :add_breadcrum

  def basic_info
    #key = params[:entity_key]
    if request.get?
      #@entity = Entity.find_by(key: key)
      entity_check() if @entity.present?
      @entity       ||= Entity.new(type_: params[:type])
      if @entity.new_record?
        add_breadcrumb "Clients", clients_path, :title => "Clients"
        add_breadcrumb "Corporation", '',  :title => "Corporation"
        add_breadcrumb "Create", '',  :title => "Create"
      else
        add_breadcrumb "Clients", clients_path, :title => "Clients"
        add_breadcrumb "Corporation", '',  :title => "Corporation"
        add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "edit"
        add_breadcrumb "Basic info", '', :title => "Basic info"
      end
    elsif request.post?
      @entity                 = Entity.new(entity_params)
      @entity.type_           = MemberType.getCorporationId
      @entity.basic_info_only = true
      @entity.user_id         = current_user.id
      if @entity.save
        AccessResource.add_access({ user: current_user, resource: @entity })
        flash[:success] = "Congratulations, you have just created a record for #{@entity.display_name}"
        return redirect_to entities_corporates_basic_info_path( @entity.key )
      else
        add_breadcrumb "Clients", clients_path, :title => "Clients"
        add_breadcrumb "Corporation", '',  :title => "Corporation"
        add_breadcrumb "Create", '',  :title => "Create"
      end
    elsif request.patch?
      #@entity                 = Entity.find_by(key: key)
      prior_entity_name = @entity.display_name
      @entity.type_           = MemberType.getCorporationId
      @entity.basic_info_only = true
      if @entity.update(entity_params)
        flash[:success] = "Congratulations, you have just made a change in the record for #{prior_entity_name}"
        return redirect_to entities_corporates_basic_info_path( @entity.key )
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
      add_breadcrumb "Corporation", '',  :title => "Corporation"
      add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "edit"
      add_breadcrumb "Contact info", '', :title => "Contact info"
    elsif request.patch?
      @entity.basic_info_only = false
      @entity.update(entity_params)
      add_breadcrumb "Clients", clients_path, :title => "Clients"
      add_breadcrumb "Corporation", '',  :title => "Corporation"
      add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "edit"
      add_breadcrumb "Contact info", '', :title => "Contact info"
      return render layout: false, template: "entities/corporates/contact_info"
    else
      raise UnknownRequestFormat
    end
    render layout: false if request.xhr?
  end

  def director
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @director = Director.find(id) if id.present?
      @director ||= Director.new
      @director.super_entity_id = @entity.id
      @director.class_name      = "Director"

      if request.get?
        if @director.new_record?
          add_breadcrumb "Clients", clients_path, :title => "Clients"
          add_breadcrumb "Corporation", '',  :title => "Corporation"
          add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
          add_breadcrumb "Director Create", '',  :title => "Director Create"
        else
          add_breadcrumb "Clients", clients_path, :title => "Clients"
          add_breadcrumb "Corporation", '',  :title => "Corporation"
          add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
          add_breadcrumb "Director", '',  :title => "Director"
        end
      end
    end
    if request.post?
      @director           = Director.new(director_params)
      @director.super_entity_id = @entity.id
      @director.class_name      = "Director"
      @director.use_temp_id
      if @director.save
        @directors = @entity.directors
        flash[:success] = "Congratulations, you have just created a record for #{@director.first_name} #{@director.last_name}, a Director of #{@entity.display_name}"
        return redirect_to entities_corporates_director_path( @entity.key, @director.id )
      else
        # return render layout: false, template: "entities/corporates/director"
        return redirect_to entities_corporates_director_path( @entity.key, @director.id )
      end
    elsif request.patch?
      prior_director_name = "#{@director.first_name} #{@director.last_name}"
      if @director.update(director_params)
        @director.use_temp_id
        @directors = @director.entity.directors
        @director.save
        flash[:success] = "Congratulations, you have just made a change in the record for #{prior_director_name}, a Director of #{@entity.display_name}"
        return redirect_to entities_corporates_director_path( @entity.key, @director.id )
      else
        return redirect_to entities_corporates_director_path( @entity.key, @director.id )
      end
    elsif request.delete?
      director = Director.find(params[:id])
      director.delete
      @entity = Entity.find_by(key: director.super_entity.key)
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @directors = @entity.directors
      # flash[:success] = "The Director Successfully Deleted."
      return redirect_to entities_corporates_directors_path( @entity.key )
      # return render layout: false, template: "entities/corporates/directors"
    end
    @director.gen_temp_id
    render layout: false if request.xhr?
  end

  def directors
    # add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"#\">Directors </a></h4></div>".html_safe
    @entity = Entity.find_by(key: params[:entity_key])
    add_breadcrumb "Clients", clients_path, :title => "Clients"
    add_breadcrumb "Corporation", '',  :title => "Corporation"
    add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
    add_breadcrumb "Directors List View", '',  :title => "Director List View"
    raise ActiveRecord::RecordNotFound if @entity.blank?
    @directors = @entity.directors
    @activeId = params[:active_id]
    render layout: false if request.xhr?
  end

  def officer
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @officer = Officer.find(id) if id.present?
      @officer ||= Officer.new
      @officer.super_entity_id = @entity.id
      @officer.class_name      = "Officer"

      if request.get?
        if @officer.new_record?
          add_breadcrumb "Clients", clients_path, :title => "Clients"
          add_breadcrumb "Corporation", '',  :title => "Corporation"
          add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
          add_breadcrumb "Officer Create", '',  :title => "Officer Create"
        else
          add_breadcrumb "Clients", clients_path, :title => "Clients"
          add_breadcrumb "Corporation", '',  :title => "Corporation"
          add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
          add_breadcrumb "Officer", '',  :title => "Officer"
        end
      end
    end
    if request.post?
      @officer           = Officer.new(officer_params)
      @officer.super_entity_id = @entity.id
      @officer.class_name      = "Officer"
      @officer.use_temp_id
      if @officer.save
        @officers = @entity.officers
        flash[:success] = "Congratulations, you have just created a record for #{@officer.first_name} #{@officer.last_name}, a Officer of #{@entity.display_name}"
        return redirect_to entities_corporates_officer_path( @entity.key, @officer.id )
        # return render layout: false, template: "entities/corporates/officers"
      else
        # return render layout: false, template: "entities/corporates/officer"
        return redirect_to entities_corporates_officer_path( @entity.key, @officer.id )
      end
    elsif request.patch?
      prior_officer_name = "#{@officer.first_name} #{@officer.last_name}"
      if @officer.update(officer_params)
        @officer.use_temp_id
        @officer.save
        @officers = @officer.entity.officers
        flash[:success] = "Congratulations, you have just made a change in the record for #{prior_officer_name}, a Officer of #{@entity.display_name}"
        return redirect_to entities_corporates_officer_path( @entity.key, @officer.id )
      else
        # return render layout: false, template: "entities/corporates/officer"
        return redirect_to entities_corporates_officer_path( @entity.key, @officer.id )
      end
    elsif request.delete?
      officer = Officer.find(params[:id])
      officer.delete
      @entity = Entity.find_by(key: officer.super_entity.key)
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @officers = @entity.officers
      # flash[:success] = "The Officer Successfully Deleted."
      return redirect_to entities_corporates_officers_path( @entity.key )
      # return render layout: false, template: "entities/corporates/officers"
    end
    @officer.gen_temp_id
    render layout: false if request.xhr?
  end

  def officers
    # add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"#\">Officers </a></h4></div>".html_safe
    @entity = Entity.find_by(key: params[:entity_key])
    add_breadcrumb "Clients", clients_path, :title => "Clients"
    add_breadcrumb "Corporation", '',  :title => "Corporation"    
    add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
    add_breadcrumb "Officers List View", '',  :title => "Officer List View"
    
    raise ActiveRecord::RecordNotFound if @entity.blank?
    @officers = @entity.officers
    @activeId = params[:active_id]
    render layout: false if request.xhr?
  end

  def stockholder
    @referrer = request.referrer
    unless request.delete?
      @entity = Entity.find_by(key: params[:entity_key])
      id      = params[:id]
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @stockholder                 = StockHolder.find(id) if id.present?
      @stockholder                 ||= StockHolder.new
      @stockholder.super_entity_id = @entity.id
      @stockholder.class_name      = "StockHolder"

      if request.get?
        if @stockholder.new_record?
          add_breadcrumb "Clients", clients_path, :title => "Clients"
          add_breadcrumb "Corporation", '',  :title => "Corporation"
          add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
          add_breadcrumb "Stockholder Create", '',  :title => "Stockholder Create"
        else
          add_breadcrumb "Clients", clients_path, :title => "Clients"
          add_breadcrumb "Corporation", '',  :title => "Corporation"
          add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
          add_breadcrumb "Stockholder", '',  :title => "Stockholder"
        end
      end
    end

    if request.post?
      @stockholder                 = StockHolder.new(stockholder_params)
      @stockholder.use_temp_id
      @stockholder.super_entity_id = @entity.id
      @stockholder.class_name      = "StockHolder"
      if (@stockholder.entity.present? || @stockholder.contact.present?) && @stockholder.save
        @stockholders = @entity.stockholders
        flash[:success] = "Congratulations, you have just created a record for #{@stockholder.first_name} #{@stockholder.last_name}, a Stockholder of #{@entity.display_name}"
        return redirect_to entities_corporates_stockholder_path( @entity.key, @stockholder.id )
      else
        @stockholder.errors.add(:stockholder, "problem creating. Check data and try again.")
        # return render layout: false, template: "entities/corporates/stockholder"
        return redirect_to entities_corporates_stockholder_path( @entity.key, @stockholder.id )
      end
    elsif request.patch?
      prior_stockholder_name = "#{@stockholder.first_name} #{@stockholder.last_name}"
      @stockholder.assign_attributes(stockholder_params)
      @stockholder.use_temp_id
      if (@stockholder.entity.present? || @stockholder.contact.present?) && @stockholder.save
        @stockholders = @entity.stockholders
        flash[:success] = "Congratulations, you have just made a change in the record for #{prior_stockholder_name}, a Stockholder of #{@entity.display_name}"
        return redirect_to entities_corporates_stockholder_path( @entity.key, @stockholder.id )
      else
        @stockholder.errors.add(:stockholder, "problem updating. Check data and try again.")
        # return render layout: false, template: "entities/corporates/stockholder"
        return redirect_to entities_corporates_stockholder_path( @entity.key, @stockholder.id )
      end
    elsif request.delete?
      stockholder = StockHolder.find(params[:id])
      stockholder.delete
      @entity = Entity.find_by(key: stockholder.super_entity.key)
      raise ActiveRecord::RecordNotFound if @entity.blank?
      @stockholders = @entity.stockholders
      # return render layout: false, template: "entities/corporates/stockholders"
      # flash[:success] = "The Stockholder Successfully Deleted"
      return redirect_to entities_corporates_stockholders_path( @entity.key )
    end
    @stockholder.gen_temp_id
    render layout: false if request.xhr?
  end

  def stockholders(entity_key = params[:entity_key])
    # add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"#\">Stockholders </a></h4></div>".html_safe
    @entity = Entity.find_by(key: entity_key)
    add_breadcrumb "Clients", clients_path, :title => "Clients"
    add_breadcrumb "Corporation", '',  :title => "Corporation"    
    add_breadcrumb "Edit: #{@entity.display_name}", '',  :title => "Edit"
    add_breadcrumb "Stockholders List View", '',  :title => "Stockholder List View"
    raise ActiveRecord::RecordNotFound if @entity.blank?
    @stockholders = @entity.stockholders
    @activeId = params[:active_id]
    render layout: false if request.xhr?
  end

  def owns
    @entity = Entity.find_by(key: params[:entity_key])
    @ownership_ = @entity.build_ownership_tree_json
    @owns_available = (@ownership_[0][:nodes] == nil) ? false : true
    @ownership = @ownership_.to_json
    add_breadcrumb "Clients", clients_path, :title => "Clients"
    add_breadcrumb "Corporation", '',  :title => "Corporation"
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
                                   :is_honorific, :has_comma, :shares_decimal_count)
  end

  def set_entity
    key = params[:entity_key]
    @entity = Entity.find_by(key: key)
  end

  def stockholder_params
    params.require(:stock_holder).permit(:temp_id, :member_type_id, :is_person, :entity_id, :first_name, :last_name, :phone1, :phone2, :fax, :email, :postal_address, :city, :state, :zip, :ein_or_ssn, :my_percentage_stockholder, :notes, :honorific, :is_honorific, :contact_id)
  end

  def officer_params
    params.require(:officer).permit(:temp_id, :member_type_id, :first_name, :last_name, :phone1, :phone2, :fax,
                                    :email, :postal_address, :city, :state, :zip, :notes, :honorific, :is_honorific,
                                    :contact_id, :office)
  end

  def director_params
    params.require(:director).permit(:temp_id, :member_type_id, :first_name, :last_name, :phone1, :phone2,
                                     :fax, :email, :postal_address, :city, :state, :zip, :honorific, :is_honorific, :contact_id)
  end

  def current_page
    @current_page = "entity"
  end

  def check_xhr_page
    unless request.xhr?
      if params[:action] != "basic_info"
        return redirect_to entities_corporates_basic_info_path(params[:entity_key], xhr: request.env["REQUEST_PATH"])
      end
    end
  end

  def add_breadcrum
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">Clients </a></h4></div>".html_safe
    if params[:entity_key] and @entity.present? and !@entity.new_record?
      add_breadcrumb ("<div class=\"pull-left\"><h4><a href=\"#{edit_entity_path(@entity.key)}\">Edit Corporation: <span id='edit-title-corp'>#{@entity.display_name}</span></a><span id='int-action-corp'></span></h4></div>").html_safe
    else
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action] == "basic_info" ? "Add" : "" } Corporation </a></h4></div>".html_safe
    end

    if params[:action] != "basic_info"
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">#{params[:action].titleize}</a></h4></div>".html_safe
    end
  end


end


class UnknownRequestFormat < Exception;
end
