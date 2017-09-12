class Admin::DefaultValuesController < ApplicationController
  layout 'admin'
  before_action :set_default_value, only: [:show, :edit, :update, :destroy]

  # GET /default_values
  def index
    @default_values = DefaultValue.where.not(entity_name: 'RandomMode')
    @random_mode = DefaultValue.where(entity_name: 'RandomMode').count() == 1
    landing_page_action = DefaultValue.where(entity_name: 'ShowLandingPage').first
    if landing_page_action.present?
      @show_landing_page = landing_page_action.value
    else
      @show_landing_page = false
    end

    initial_sign_in_modal_action = DefaultValue.where(entity_name: 'ShowInitialSignInModal').first
    if initial_sign_in_modal_action.present?
      @show_initial_sign_in_modal = initial_sign_in_modal_action.value
    else
      @show_initial_sign_in_modal = false
    end

    @greeting = DefaultValue.where(entity_name: 'Greeting').first.try(:value)
    @show_personnel_list = DefaultValue.where(entity_name: 'ShowPersonnel').first.try(:value)
  end

  # GET /default_values/1
  def show
  end

  # GET /default_values/new
  def new
    @default_value = DefaultValue.new
    @title = "Property - Add a Default Value"
    @entity = ["Property"]
    @entity_fields = Property.column_names.map(&:camelize)
    @type_options = DefaultValue::PROPERTY_OPTIONS
  end

  def new_property
    @default_value = DefaultValue.new
    @title = "Property - Add a Default Value"
    @entity = ["Property"]
    @entity_fields = Property.column_names.map(&:camelize)
    @type_options = DefaultValue::PROPERTY_OPTIONS
    render :new
  end

  def new_terms
    @default_value = DefaultValue.new
    @title = "Terms - Add a Default Value"
    @entity = ["TransactionTerm"]
    @entity_fields = TransactionTerm.column_names.map(&:camelize)
    @type_options = DefaultValue::TRANSACTION_TERM_OPTIONS
    render :new
  end

  def new_purchase_property
    @default_value = DefaultValue.new(mode: 'buy')
    @title = "Purchase Property - Add a Default Value"
    @entity = ["TransactionProperty"]
    @entity_fields = TransactionProperty.column_names.map(&:camelize)
    @type_options = DefaultValue::TRANSACTION_PROPERTY_OPTIONS
    render :new
  end

  def new_sell_property
    @default_value = DefaultValue.new(mode: 'sale')
    @title = "Sell Property - Add a Default Value"
    @entity = ["TransactionProperty"]
    @entity_fields = TransactionProperty.column_names.map(&:camelize)
    @type_options = DefaultValue::TRANSACTION_PROPERTY_OPTIONS
    render :new
  end

  def new_sale_transaction
    @default_value = DefaultValue.new(mode: 'sale')
    @title = "Sale Transaction - Add a Default Value"
    @entity = ["TransactionSale"]
    @entity_fields = TransactionSale.column_names.map(&:camelize)
    @type_options = DefaultValue::TRANSACTION_SALE_OPTIONS
    render :new
  end

  # GET /default_values/1/edit
  def edit
    @title = "#{@default_value.entity_name} - Edit the Default Value"
    @entity = [@default_value.entity_name]
    @entity_fields = @default_value.entity_name.constantize.column_names.map(&:camelize)
    @type_options = DefaultValue.send("#{@default_value.entity_name.underscore.downcase}_options".to_sym)
  end

  # POST /default_values
  def create
    @default_value = DefaultValue.new(default_value_params)

    if cleanup_and_save
      redirect_to admin_default_values_url, notice: 'Default value was successfully created.'
    else
      render :new
    end
  end

  def cleanup_and_save
    to_be_removed = DefaultValue.where(entity_name: @default_value.entity_name,
                                    attribute_name: @default_value.attribute_name).pluck('id')
    flag = @default_value.save

    DefaultValue.where(id: to_be_removed).destroy_all if flag

    return flag
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

  def random_mode
    if !params[:random_mode].nil?
      # activate random mode
      DefaultValue::RANDOM_MODE.each do |rec|
        @default_value = DefaultValue.new(entity_name: rec[:entity],
                          attribute_name: rec[:attribute], value_type: rec[:vtype])
        cleanup_and_save
      end
    else
      # deactivate random mode
      DefaultValue::RANDOM_MODE.each do |rec|
        DefaultValue.where(entity_name: rec[:entity],
                          attribute_name: rec[:attribute], value_type: rec[:vtype]).destroy_all
      end
    end
    redirect_to admin_default_values_url
  end

  def toggle_landing_page
    landing_page_action = DefaultValue.where(entity_name: 'ShowLandingPage').first
    if landing_page_action.present?
      landing_page_action.update(value: params[:toggle_landing_page])
    else
      DefaultValue.create(entity_name: 'ShowLandingPage', value: params[:toggle_landing_page])
    end
    redirect_to admin_default_values_url
  end

  def toggle_initial_sign_in_modal
    initial_sign_in_modal_action = DefaultValue.where(entity_name: 'ShowInitialSignInModal').first
    if initial_sign_in_modal_action.present?
      initial_sign_in_modal_action.update(value: params[:toggle_initial_sign_in_modal])
    else
      DefaultValue.create(entity_name: 'ShowInitialSignInModal', value: params[:toggle_initial_sign_in_modal])
    end
    redirect_to admin_default_values_url
  end

  def set_greeting
    greeting_text = DefaultValue.where(entity_name: 'Greeting').first
    if greeting_text.present?
      greeting_text.update(value: params[:greeting])
    else
      DefaultValue.create(entity_name: 'Greeting', value: params[:greeting])
    end
    redirect_to admin_default_values_url
  end

  def toggle_personnel_to_user
    toggle_personnel = DefaultValue.where(entity_name: 'ShowPersonnel').first
    if toggle_personnel.present?
      toggle_personnel.update(value: params[:toggle_personnel_to_user])
    else
      DefaultValue.create(entity_name: 'ShowPersonnel', value: params[:toggle_personnel_to_user])
    end
    redirect_to admin_default_values_url
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
