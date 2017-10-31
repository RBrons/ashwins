class EntitiesController < ApplicationController

  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :current_page
  before_action :add_breadcrum

  # GET /entities
  # GET /entities.json
  def xhr_list
    @entities      = Entity.where(id: AccessResource.get_ids({user: current_user, resource_klass: 'Entity'})).where.not(name: [nil, '']).order(created_at: :desc)
    @stockholder   = params[:stockholder].to_b
    render layout: false
  end

  def index
    @entities = Entity.where(id: AccessResource.get_ids({user: current_user, resource_klass: 'Entity'}))
  end

  # GET /entities/1
  # GET /entities/1.json
  def show
    render json: @entity.to_json if request.xhr?
  end

  # GET /entities/new
  def new
    type           = params[:type]
    member_type_id = MemberType.find_by(name: type).try(:id) || 0
    @entity        = Entity.new(type_: member_type_id)
    @stockholder   = params[:stockholder].to_b
    return redirect_to entities_individuals_basic_info_path(type: member_type_id) if @entity.Individual?
    return redirect_to entities_corporates_basic_info_path(type: member_type_id) if @entity.Corporation?
    return redirect_to entities_llc_basic_info_path(type: member_type_id) if @entity.LLC?
    return redirect_to entities_llp_basic_info_path(type: member_type_id) if @entity.LLP?
    return redirect_to entities_partnership_basic_info_path(type: member_type_id) if @entity.Partnership?
    return redirect_to entities_limited_partnership_basic_info_path(type: member_type_id) if @entity.LimitedPartnership?
    return redirect_to entities_sole_proprietorship_basic_info_path(type: member_type_id) if @entity.SoleProprietorship?
    return redirect_to entities_trust_basic_info_path(type: member_type_id) if @entity.Trust?
    return redirect_to entities_guardianship_basic_info_path(type: member_type_id) if @entity.Guardianship?
    return redirect_to entities_tenancy_in_common_basic_info_path(type: member_type_id) if @entity.TenancyinCommon?
    return redirect_to entities_joint_tenancy_basic_info_path(type: member_type_id) if @entity.JointTenancy?
    return redirect_to entities_tenancy_by_entirety_basic_info_path(type: member_type_id) if @entity.TenancyByTheEntirety?
    return redirect_to entities_power_of_attorney_basic_info_path(type: member_type_id) if @entity.power_of_attorney?
    render layout: false, template: "entities/xhr_new" if request.xhr?
  end

  # GET /entities/1/edit
  def edit
    return redirect_to entities_individuals_basic_info_path(@entity.key) if @entity.Individual?
    return redirect_to entities_corporates_basic_info_path(@entity.key) if @entity.Corporation?
    return redirect_to entities_llc_basic_info_path(@entity.key) if @entity.LLC?
    return redirect_to entities_llp_basic_info_path(@entity.key) if @entity.LLP?
    return redirect_to entities_partnership_basic_info_path(@entity.key) if @entity.Partnership?
    return redirect_to entities_limited_partnership_basic_info_path(@entity.key) if @entity.LimitedPartnership?
    return redirect_to entities_sole_proprietorship_basic_info_path(@entity.key) if @entity.SoleProprietorship?
    return redirect_to entities_trust_basic_info_path(@entity.key) if @entity.Trust?
    return redirect_to entities_guardianship_basic_info_path(@entity.key) if @entity.Guardianship?
    return redirect_to entities_tenancy_in_common_basic_info_path(@entity.key) if @entity.TenancyinCommon?
    return redirect_to entities_joint_tenancy_basic_info_path(@entity.key) if @entity.JointTenancy?
    return redirect_to entities_tenancy_by_entirety_basic_info_path(@entity.key) if @entity.TenancyByTheEntirety?
    return redirect_to entities_power_of_attorney_basic_info_path(@entity.key) if @entity.power_of_attorney?
  end

  # POST /entities
  # POST /entities.json
  def create
    @entity                 = Entity.new(entity_params)
    @stockholder            = params[:stockholder].to_b
    @entity.basic_info_only = true if request.xhr?
    respond_to do |format|
      if @entity.save
        AccessResource.add_access(user: current_user, resource: @entity)
        format.html { redirect_to @entity, notice: 'Entity was successfully created.' }
        format.json { render action: 'show', status: :created, location: @entity }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
        format.js {render layout: false, template: "entities/xhr_new"}
      end
    end
  end

  # PATCH/PUT /entities/1
  # PATCH/PUT /entities/1.json
  def update
    respond_to do |format|
      if @entity.update(entity_params)
        # cookies['update_entity_flag'] = { value: true, expires: 1.hour.from_now }
        format.html { redirect_to entities_corporates_stockholder_path( @entity.key ), notice: 'Entity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entities/1
  # DELETE /entities/1.json
  def destroy
    entity = @entity
    # TransactionSale
    klazz         = 'TransactionSale'
    transactions = klazz.constantize.with_deleted.joins(:transaction_main)
    transactions = transactions.where('transaction_mains.init' => false, 'transaction_mains.user_id' => current_user.id)
    transactions = transactions.where('transactions.deleted_at' => nil)

    transactions.each do |t|
      if t.relinquishing_seller_entity_id == entity.id
        t.main.destroy if t.main.present?
      end
    end

    # TransactionPurchase
    klazz         = 'TransactionPurchase'
    transactions = klazz.constantize.with_deleted.joins(:transaction_main)
    transactions = transactions.where('transaction_mains.init' => false, 'transaction_mains.user_id' => current_user.id)
    transactions = transactions.where('transactions.deleted_at' => nil)

    transactions.each do |t|
      if t.replacement_purchaser_entity_id == entity.id
        t.destroy if t.main.present?
      end
    end

    # ICPs
    case entity.entity_type.try(:name)
      when "LLC"
        (entity.members + entity.managers).each do |e|
          e.destroy
        end
      when "LLP"
        entity.partners.each do |e|
          e.destroy
        end
      when "Power of Attorney"
        entity.agents.each do |e|
          e.destroy
        end
      when "Trust"
        (entity.beneficiaries + entity.trustees + entity.settlors).each do |e|
          e.destroy
        end
      when "Joint Tenancy with Rights of Survivorship (JTWROS)"
        entity.joint_tenants.each do |e|
          e.destroy
        end
      when "Limited Partnership"
        (entity.general_partners + entity.limited_partners).each do |e|
          e.destroy
        end
      when "Tenancy in Common"
        listA = entity.tenants_in_common.map { |m| ["#{m.name} - #{m.my_percentage}", m.entity.present? ? edit_entity_path(m.entity.key) : ( m.contact.present? ? edit_contact_path(m.contact) : "#")] }
      when "Corporation"
        (entity.stockholders + entity.directors + entity.officers).each do |e|
          e.destroy
        end
      when "Partnership"
        entity.partners.each do |e|
          e.destroy
        end
      when "Tenancy by the Entirety"
        entity.spouses.each do |e|
          e.destroy
        end
      else
        # No need to handle
    end

    if m = Member.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Manager.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = LimitedPartner.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Beneficiary.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Trustee.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Settlor.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = GeneralPartner.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = StockHolder.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Officer.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Director.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Partner.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Principal.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Agent.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = TenantInCommon.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = JointTenant.find_by_entity_id(entity.id)
      m.destroy
    end

    if m = Spouse.find_by_entity_id(entity.id)
      m.destroy
    end

    #Properties
    Property.where(owner_entity_id: entity.id).each do |p|
      p.update_attributes(:owner_entity_id => 0, :owner_person_is => 0)
    end

    entity.destroy
    respond_to do |format|
      format.html { redirect_to clients_path }
      format.json { render json: {success: true} }
    end
  end

  def share_or_interest
    val = params[:val]
    case val
      when "Corporation"
        text = "entity[number_of_share]"
      when "LLC"
        text = "entity[total_membership_interest]"
      when "LLP"
        text = "entity[total_membership_interest]"
      when "Tenancy in Common"
        text = "entity[total_undivided_interest]"
      when "Limited Partnership"
        text = "entity[total_partnership_interest]"
    end
    render text: text
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_entity
    @entity    = Entity.find_by(key: params[:id])
    @entity  ||= Entity.find_by(id: params[:id])
    @entity  ||= Entity.find_by(key: params[:entity_key])
    raise ActiveRecord::RecordNotFound if @entity.blank?
    entity_check()
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def entity_params
    params.require(:entity).permit(:name, :address, :type_, :jurisdiction, :number_of_assets,
                                   :date_of_formation, :m_date_of_formation, :number_of_share,
                                   :has_comma, :legal_ending)
  end

  private
  def current_page
    @current_page = 'entity'
  end

  def add_breadcrum
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">Clients </a></h4></div>".html_safe

    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\"> #{params[:action] == "new" ? "Add" : params[:action].titleize} #{"Estate" if params[:type] == "Estate" } </a></h4></div>".html_safe

  end
end
