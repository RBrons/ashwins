class Admin::TenantsController < Admin::AdminController
  def resource_class_with_condition
    Tenant
  end

  before_action :set_tenant, only: [:show, :edit, :update, :destroy]

  # GET /tenants
  def index
    @tenants = Tenant.all
  end

  # GET /tenants/1
  def show
  end

  # GET /tenants/new
  def new
    @tenant = Tenant.new
  end

  # GET /tenants/1/edit
  def edit
  end

  # POST /tenants
  def create
    @tenant = Tenant.new(tenant_params)

    if @tenant.save
      #redirect_to @tenant, notice: 'Tenant was successfully created.'
      respond_to do |format|
        format.html { redirect_to admin_tenants_url, notice: 'Tenant was successfully created.' }
        format.json { render :json => @tenant.to_json  }
      end
    else
      render :new
    end
  end

  # PATCH/PUT /tenants/1
  def update
    if @tenant.update(tenant_params)
      #redirect_to @tenant, notice: 'Tenant was successfully created.'
      respond_to do |format|
        format.html { redirect_to admin_tenants_url, notice: 'Tenant was successfully updated.' }
        format.json { render :json => @tenant.to_json  }
      end    
    else
      render :edit
    end
  end

  # DELETE /tenants/1
  def destroy
    @tenant.destroy
    respond_to do |format|
      format.html { redirect_to admin_tenants_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tenant_params
      params.require(:tenant).permit(:name, :user_id)
    end
end
