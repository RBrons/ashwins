class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :current_page
  before_action :add_breadcrum
  # GET /clients
  # GET /clients.json
  def index
    grp_ = nil
    @entities = nil
    @groups = []
    @current_grp = params[:grp] || '0'
    #params[:grp] = @current_grp
    #@entities_present = []
    #@entities_absent = []
    if request.post?
      if params[:form_type] == 'addmultitogroup'
        grp_ = current_user.groups.where(id: params[:group_id]).first
        entities_ = []
        ids    = params[:multi_add_entities].split(',').map(&:to_i).compact
        entities_ = Entity.where(id: ids) if !grp_.nil?
        entities_.each do |e|
          begin
            grp_.group_members.create!(gmember: e)
          rescue => exception
            # add exception handling code
          end
        end
      elsif params[:form_type] == 'removemultifromgroup' && params[:group_id] && params[:group_id] != '0'
        grp_ = current_user.groups.where(id: params[:group_id]).first
        ids    = params[:multi_remove_entities].split(',').map(&:to_i).compact
        GroupMember.where(group_id: grp_.id, gmember_id: ids,
          gmember_type: 'Entity').delete_all if !grp_.nil?
      end
        @current_grp = grp_.id.to_s
        params[:grp] = @current_grp
    end
    if @current_grp != '0'
      grp_ = current_user.groups.where(id: @current_grp).first
      if grp_
        @entities = grp_.entities.where(user_id: current_user.id)
        #@entities_present = Entity.where(id: @entities).pluck('name, id')
        #@entities_absent = Entity.where.not(id: @entities).pluck('name, id')
      end
    else
      @groups = current_user.groups.where(gtype: 'Entity').pluck('name, id')
      @entities   = Entity.with_deleted.where(id: AccessResource.get_ids({user: current_user, resource_klass: 'Entity'}))
      @entities   = @entities.where(deleted_at: nil) unless params[:trashed].to_b
      @entities   = @entities.where.not(deleted_at: nil) if params[:trashed].to_b
    end
    @entities   = @entities.order(created_at: :desc).paginate(page: params[:page], per_page: sessioned_per_page)
    @activeId = params[:active_id]
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">List </a></h4></div>".html_safe
    render layout: false if request.xhr?
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client     = Client.new
    if params[:client_type]
      @client     = Client.new(client_type: "individual")
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients/new\"> Add #{params[:client_type].titleize} </a></h4></div>".html_safe
    end
    render layout: false, template: "contacts/new" if request.xhr?
  end

  # GET /clients/1/edit
  def edit
    @youarehere = [view_context.link_to("Clients", view_context.clients_path), "Edit"] ## You Are Here ##
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    respond_to do |format|
      if @client.save
        AccessResource.add_access({ user: current_user, resource: @client })
        format.html { redirect_to clients_path, notice: 'Client was successfully created.' }
        format.json { render action: 'show', status: :created, location: @client }
        format.js {render layout: false, template: "clients/new"}
      else
        format.html { add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients/new\"> Add #{@client.client_type.titleize} </a></h4></div>".html_safe
        render action: 'new' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
        format.js {render layout: false, template: "clients/new"}
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to clients_path, notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end

  def address
    val      = params[:val]
    @clients = Client.where('info LIKE ?', "%#{val}%")
    if @clients.blank?
      index()
    end
    render layout: false
  end

  def multi_delete
    common_multi_delete
  end

  private
  def current_page
    @current_page = 'client'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find_by(key: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:client).permit(:first_name, :last_name, :entity_id, :phone1, :phone2, :fax, :email, :postal_address,
                                   :notes, :city, :state, :zip, :is_person, :ein_or_ssn, :honorific, :is_honorific, :client_type)
  end

  def add_breadcrum
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/clients\">Clients </a></h4></div>".html_safe
  end

end
