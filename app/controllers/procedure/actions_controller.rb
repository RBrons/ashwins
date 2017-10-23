class Procedure::ActionsController < ApplicationController
  before_action :set_procedure_action, only: [:show, :edit, :update, :destroy]

  # GET /procedure/actions
  # GET /procedure/actions.json
  def index
    @action = Procedure::Action.find_by(key: params[:pid])
    @comments = Comment.where(commentable_id: @action.id, commentable_type: @action.class.to_s, deleted: false).order(id: :asc)
    render layout: false, template: 'procedure/actions/show'
  end

  # GET /procedure/actions/1
  # GET /procedure/actions/1.json
  def show
    @comments = Comment.where(commentable_id: @procedure_action.id, commentable_type: @procedure_action.class.to_s, deleted: false).order(id: :asc)
  end

  # GET /procedure/actions/new
  def new
    procedure = Procedure.find_by(key: params[:id])
    @procedure_action = Procedure::Action.new(procedure_id: procedure.id)
    render layout: false
  end

  # GET /procedure/actions/1/edit
  def edit
  end

  # POST /procedure/actions
  # POST /procedure/actions.json
  def create
    @procedure_action = Procedure::Action.new(procedure_action_params)
    respond_to do |format|
      if @procedure_action.save
        format.html { render layout: false, template: 'procedure/actions/created'}
        format.json { render action: 'show', status: :created, location: @procedure_action }
      else
        format.html { render action: 'new' }
        format.json { render json: @procedure_action.errors, status: :unprocessable_entity }
      end
    end
  end

  def created
  end

  # PATCH/PUT /procedure/actions/1
  # PATCH/PUT /procedure/actions/1.json
  def update
    title, description = params[:title], params[:description]
    if title.present?
      @procedure_action.title = title
      @procedure_action.save
      render text: title
    end
    if description.present?
      @procedure_action.description = description
      @procedure_action.save
      render text: description
    end
  end

  # DELETE /procedure/actions/1
  # DELETE /procedure/actions/1.json
  def destroy
    @procedure_action.destroy
    respond_to do |format|
      format.html { redirect_to procedure_actions_url }
      format.json { head :no_content }
    end
  end

  def checklist_with_checkbox
    if request.patch?
      id = params[:id]
      checklist = Procedure::Action::Checklist.find(id)
      checklist.update_column(:checked, params[:checked].to_b)
      render text: 'done'
    else
      @key = params[:id]
      action = Procedure::Action.find_by(key: @key)
      @checklists = action.checklists
      render layout: false
    end
  end

  def checklist
    if request.delete?
      id = params[:id]
      checklist = Procedure::Action::Checklist.find(id)
      checklist.delete
      render text: 'ok'
    else
      @key = params[:id]
      action = Procedure::Action.find_by(key: @key)
      if request.post?
        Procedure::Action::Checklist.create(action_id: action.id, title: params[:title])
      end
      @checklists = action.checklists
      render layout: false
    end
  end

  def checklist_update
    id = params[:id]
    checklist = Procedure::Action::Checklist.find(id)
    checklist.update(title: params[:value])
    render text: params[:value]
  end  

  def member
    @action = Procedure::Action.find_by(key: params[:id])
    if request.post?
      email           = params[:email]
      if email.email?
        user   = User.find_by(email: email)
        user ||= Users::Unregistered.find_or_create_by(email: email)
        if user.class.to_s == 'User'
          access_resource = AccessResource.find_or_create_by(resource_id: @action.id, resource_klass: @action.class.to_s, user_id: user.id)
        else
          access_resource = AccessResource.find_or_create_by(resource_id: @action.id, resource_klass: @action.class.to_s, unregistered_u_k: user.key)
        end
        access_resource.permission_type = params[:permission_type]
        access_resource.can_access = (user.class.to_s == 'User')
        access_resource.save
        ######### Send Email Notification #########
        options                         = {}
        options[:user]                  = user
        options[:work_group]            = @action.title
        options[:owner_name_with_email] = "<#{current_user.email}>"
        options[:permission_type]       = access_resource.permission_type_
        options[:work_group_id]         = @action.key
        # UserMailer.work_group_access_notify_with_signup(options).deliver
        ######### Send Email Notification #########
      else
        flash[:notice] = 'Invalid Email'
      end
    end
    render layout: false
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_procedure_action
    @procedure_action = Procedure::Action.find_by(key: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def procedure_action_params
    params.require(:procedure_action).permit(:title, :procedure_id, :deleted, :key)
  end
end
