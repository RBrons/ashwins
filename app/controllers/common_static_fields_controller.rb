class CommonStaticFieldsController < ApplicationController
  before_action :set_common_static_field, only: [:show, :edit, :update, :destroy]

  # GET /common_static_fields
  # GET /common_static_fields.json
  def index
    @common_static_fields = CommonStaticField.all
  end

  # GET /common_static_fields/1
  # GET /common_static_fields/1.json
  def show
  end

  # GET /common_static_fields/new
  def new
    @common_static_field = CommonStaticField.new
  end

  # GET /common_static_fields/1/edit
  def edit
  end

  # POST /common_static_fields
  # POST /common_static_fields.json
  def create
    @common_static_field = CommonStaticField.new(common_static_field_params)

    respond_to do |format|
      if @common_static_field.save
        format.html { redirect_to @common_static_field, notice: 'Common static field was successfully created.' }
        format.json { render action: 'show', status: :created, location: @common_static_field }
      else
        format.html { render action: 'new' }
        format.json { render json: @common_static_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /common_static_fields/1
  # PATCH/PUT /common_static_fields/1.json
  def update
    respond_to do |format|
      if @common_static_field.update(common_static_field_params)
        format.html { redirect_to @common_static_field, notice: 'Common static field was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @common_static_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /common_static_fields/1
  # DELETE /common_static_fields/1.json
  def destroy
    @common_static_field.destroy
    respond_to do |format|
      format.html { redirect_to common_static_fields_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_common_static_field
      @common_static_field = CommonStaticField.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def common_static_field_params
      params.require(:common_static_field).permit(:type_is, :title)
    end
end
