class Admin::DefaultValuesController < ApplicationController
  layout 'admin'
  before_action :set_default_value, only: [:show, :edit, :update, :destroy]

  # GET /default_values
  def index
    @default_values = DefaultValue.all
  end

  # GET /default_values/1
  def show
  end

  # GET /default_values/new
  def new
    @default_value = DefaultValue.new
  end

  # GET /default_values/1/edit
  def edit
  end

  # POST /default_values
  def create
    @default_value = DefaultValue.new(default_value_params)

    if @default_value.save
      redirect_to admin_default_values_url, notice: 'Default value was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /default_values/1
  def update
    if @default_value.update(default_value_params)
      redirect_to admin_default_values_url, notice: 'Default value was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /default_values/1
  def destroy
    @default_value.destroy
    redirect_to admin_default_values_url, notice: 'Default value was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_default_value
      @default_value = DefaultValue.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def default_value_params
      params.require(:default_value).permit!
    end

end
