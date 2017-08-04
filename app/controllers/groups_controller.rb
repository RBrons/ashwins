class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  def index
    @groups = Group.all
  end

  # GET /groups/1
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
    @groups = [["", 0]] + Group.all.pluck('name, id') 
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    if @group.save
      #redirect_to @group, notice: 'Group was successfully created.'
      respond_to do |format|
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :json => @group.to_json  }
      end
    else
      render :new
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      #redirect_to @group, notice: 'Group was successfully created.'
      respond_to do |format|
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :json => @group.to_json  }
      end    
    else
      render :edit
    end
  end

  # DELETE /groups/1
  def destroy
    grps = [@group]
    if @group.children.count == 1
      child = @group.children.first
      child.parent_id = @group.parent_id
      child.save
    else
      grps = grps + @group.children
    end
    grps.each do |grp|
      grp.destroy
    end
    respond_to do |format|
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :json => {ok: "ok".to_json}  }
      end
    #redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:name, :parent_id, :gtype)
    end
end
