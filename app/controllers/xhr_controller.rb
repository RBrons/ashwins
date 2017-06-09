class XhrController < ApplicationController

  include ApplicationHelper

  layout false

  # def owns_treeview
  #   result = [{text: "Parent1", nodes: [{text: "Child1"}]}, {text: "Parent2"}]
  #   render :json => result
  # end

  def save_transaction_subtab
    tp_id = params[:id]
    TransactionProperty.find(tp_id).update(current_step_subtab: params[:subtab])
    render :json => {status: 'success'}
  end

  def add_new_tenant
    if new_tenant = current_user.tenants.create(name: params[:name])
      render :json => {status: "success", id: new_tenant.id}
    else
      render :json => {status: "error"}
    end
  end

  def get_rent_table
    @property = Property.find(params[:id])
    @rent_tables = @property.rent_tables.where(version: params[:version])
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
  end

  def entity_groups
    @groups = [{id: '0', parent: '#', text: 'All Clients'}]
    groups = Group.where(gtype: 'Entity')
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
    groups = Group.where(gtype: 'Entity', parent_id: params[:id])
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

end
