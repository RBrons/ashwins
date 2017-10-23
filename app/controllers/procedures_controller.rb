class ProceduresController < ApplicationController
  before_action :set_procedure, only: [:show, :edit, :update, :destroy]

  # GET /procedures
  # GET /procedures.json
  def index
    @procedures = Procedure.all
  end

  # GET /procedures/1
  # GET /procedures/1.json
  def show
    @procedure_actions = @procedure.actions
  end

  # GET /procedures/new
  def new
    property   = Property.find_by(key: params[:pid])
    @procedure = Procedure.new(property_id: property.id)
    render layout: false
  end

  # GET /procedures/1/edit
  def edit
    render layout: false
  end

  # POST /procedures
  # POST /procedures.json
  def create
    @procedure = Procedure.new(procedure_params)
    respond_to do |format|
      if @procedure.save
        format.html { render layout: false, template: 'procedures/created' }
        format.json { render action: 'show', status: :created, location: @procedure }
      else
        format.html { render action: 'new' }
        format.json { render json: @procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  def created
  end

  # PATCH/PUT /procedures/1
  # PATCH/PUT /procedures/1.json
  def update
    respond_to do |format|
      if @procedure.update(procedure_params)
        format.html { redirect_to property_path(@procedure.property.key), notice: 'Procedure was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /procedures/1
  # DELETE /procedures/1.json
  def destroy
    @procedure.destroy
    respond_to do |format|
      format.html { redirect_to procedures_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_procedure
    @procedure = Procedure.find_by(key: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def procedure_params
    params.require(:procedure).permit(:title, :property_id, :deleted, :key)
  end
end
