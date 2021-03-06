class XhrController < ApplicationController

  include ApplicationHelper

  layout false

  # def owns_treeview
  #   result = [{text: "Parent1", nodes: [{text: "Child1"}]}, {text: "Parent2"}]
  #   render :json => result
  # end

  def save_transaction_subtab
    tp_id = params[:id]
    if params[:subtab]
      TransactionProperty.find(tp_id).update(current_step_subtab: params[:subtab])
    end

    if params[:sub_subtab]
      TransactionProperty.find(tp_id).update(current_step_sub_subtab: params[:sub_subtab])
    end

    render :json => {status: 'success'}
  end

  def add_new_tenant
    if new_tenant = current_user.tenants.create(name: params[:name])
      render :json => {status: "success", id: new_tenant.id}
    else
      render :json => {status: "error"}
    end
  end

  def property_comments
    @property = Property.find(params[:id])
    @user = User.find(params[:user_id])
    @comments = @property.comments.where(user_id: @user.id, comment_type: params[:type], deleted: false).order(created_at: :desc)
    
    render json: render_to_string(template: 'xhr/property_comments', locals: { comments: @comments })
  end

  def clients_delete_warning
    entity = Entity.find_by_key(params[:key])
    @html = clients_delete_warning_message(entity)
  end

  def contacts_delete_warning
    contact = Contact.find(params[:id])
    @html = contacts_delete_warning_message(contact)
  end

  def properties_delete_warning
    property = Property.find_by_key(params[:key])
    @html = properties_delete_warning_message(property)
  end

  def add_property_comment
    @property = Property.find(params[:id])
    @user = User.find(params[:user_id])
    @typeComment = params[:type]
    @content = params[:comment]
    # @comments = @property.comments.where(user_id: @user.id, comment_type: params[:type]).order(created_at: :desc)
    # @html = (@comments.blank?) ? "<p>No Comments!</p>".html_safe : property_comments_html(@comments)
    if @comment = Comment.create(user_id: @user.id, comment_type: @typeComment, comment: @content, commentable: @property)
      render :json => {status: "success", length: @property.comments.where(user_id: @user.id, comment_type: params[:type], deleted: false).count}
    else
      render :json => {status: "error"}
    end
  end

  def clients_options_html
    obj = (params[:id].present?) ? SuperEntity.find(params[:id]) : nil
    @html = options_html(params[:client_type], params[:is_person], obj, params[:cid])
  end

  def client_entity
    val          = params[:val]
    @stockholder = params[:stockholder].to_b
    @entities    = Entity.where("name LIKE ?", "%#{val}%")
  end

  def entity_type_list
    #@types = MemberType.objects
    #MemberType.InitMemberTypes if @types.nil?
    @types = MemberType.objects

    # as per card here - https://trello.com/c/XsDTR0MC/505-redo-clients-modal-comment-out-guardianship
    # And further conversation on skype - change only new client modal, NOT other modal with entity type selection

    if params[:design_with_labels] == "1"
      render "entity_type_list_with_groups"
    else
      render "entity_type_list"
    end

  end

  def entity_groups
    @groups = [{id: '0', parent: '#', text: 'All Clients'}]
    groups = current_user.groups.where(gtype: 'Entity')
    groups.each do |grp|
      obj = {id: grp.id.to_s, parent: grp.parent_id.to_s,
        text: (grp.name + ' <a href="#" class="addtogroup" id="grp_' + grp.id.to_s + '"><img ' +
        ' src="/assets/plusCyan.png" id="igrp_' + grp.id.to_s + '"></img></a>').html_safe }
      @groups << obj
    end
    render :json => @groups.to_json
  end

  # def get_property_data_for_transaction
  #   @property = Property.find(params[:id])

  #   render :json => {cap: @property.cap_rate, rent: @property.current_rent, price: @property.price, image: @property.cl_image_public_id}
  # end

  def entity_child_groups
    @groups = []
    groups = current_user.groups.where(gtype: 'Entity', parent_id: params[:id])
    groups.each do |grp|
      obj = {id: grp.id.to_s, parent: '0', text: grp.name}
      @groups << obj
    end
    render :json => @groups.to_json
  end

  def owns_list
    if request.xhr?
      @entity = Entity.where(id: params[:id]).first
      if !@entity.nil?
        result = owns(@entity)
        retArr = []
        result.each do |record|
          obj = {id: record[3]}
        end
      end
    end
  end

  def create_entity
    entity_params = params.require(:entity).permit(:name, :first_name, :last_name, :type_, :legal_ending).merge({date_of_formation: Time.zone.now })
    @entity = Entity.new(entity_params)
    @entity.basic_info_only = true
    @entity.user_id = current_user.id
    if params[:entity_type] == 'individual'
      @entity.type_ = MemberType.getIndividualId
      @entity.name = @entity.first_name + ' ' + @entity.last_name
    end
    begin
      if @entity.save
        AccessResource.add_access({user: current_user, resource: Entity.find(@entity.id)})
        render json: @entity
      else
        render json: false
      end
    rescue Exception => e
      render json: e.message
    end

  end

  def update_entity
    entity_params = params.require(:entity).permit(:id, :name, :first_name, :last_name, :type_, :legal_ending)
    @entity = Entity.where(id: entity_params[:id]).first
    if params[:entity_type] == 'individual'
      entity_params[:type_] = MemberType.getIndividualId
      entity_params[:name] = entity_params[:first_name] + ' ' + entity_params[:last_name]
      entity_params[:legal_ending] = nil
    else
      entity_params[:first_name] = nil
      entity_params[:last_name] = nil
    end
    if @entity.update(entity_params)
      render json: @entity
    else
      render json: false
    end
  end

  def skip_user_setup
    user = current_user
    user.update(:skipped_user_setup => true)
  end

  # Save lease tab that user was on last
  def save_property_lease_tab
    property = Property.find(params[:id])
    if property.update(last_sub_tab: params[:last_sub_tab])
      render json: {status: 'success'}
    else
      render json: {status: 'failed'}
    end
  end

  # Get all rent by date
  def get_all_rent_by_date
    property = Property.find(params[:id])
    filter_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    lease_start_date = property.rent_commencement_date
    lease_end_date = property.rent_commencement_date + property.lease_duration_in_years.years
    
    if property.optional_extensions_status
      lease_end_date = lease_end_date + (property.number_of_option_period * property.length_of_option_period).years
    end

    if lease_start_date <= filter_date && filter_date <= lease_end_date
      rent_tables = property.rent_tables.where("version = ? AND start_year <= ? AND end_year >= ?", property.rent_table_version, params[:year].to_i, params[:year].to_i)
    else
      rent_tables = []
    end
    daily_table_html = render_to_string :template => "xhr/daily_rent", :locals => {:rent_tables => rent_tables, :filter_date => filter_date}
    
    term_status = property.check_in_which_term filter_date
    term_wizard_html = render_to_string :template => "xhr/lease_term_wizard", :locals => {:property => property, :term_status => term_status}
    
    render json: { daily_rent: daily_table_html, term_wizard: term_wizard_html }
  end

  def manual_rent_commencement_date
    @date_of_lease = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
  end

end
