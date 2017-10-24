class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit, :destroy]
  before_action :current_page
  before_action :add_breadcrum
  # before_action :validate_ipp, except: [:index]

  # GET /properties
  # GET /properties.json
  def index
    @properties = Property.with_deleted.where(id: AccessResource.get_ids(resource_klass: 'Property', user: current_user))
    @properties = @properties.where(deleted_at: nil) unless params[:trashed].to_b
    @properties = @properties.where.not(deleted_at: nil) if params[:trashed].to_b
    @last = @properties.try(:last).try(:id) || 0
    if params["purchased"]
      if ((params["purchased"]["accepted"] == "1") && (params["prospective_purchase"]["accepted"] == "1"))
      elsif ((params["purchased"]["accepted"] == "0") && (params["prospective_purchase"]["accepted"] == "0"))
        @properties = @properties.where.not(ownership_status: ['Prospective Purchase', 'Purchased'])
      else
        @properties = @properties.where(ownership_status: 'Purchased') if params["purchased"]["accepted"] == "1"
        @properties = @properties.where(ownership_status: 'Prospective Purchase') if params["prospective_purchase"]["accepted"] == "1"
      end
    end
    @properties = @properties.order(created_at: :desc).paginate(page: params[:page], per_page: sessioned_per_page)
    @activeId = params[:active_id]
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"#\"> List </a></h4></div>".html_safe

    render template: 'properties/xhr_list', layout: false if request.xhr?
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
    @procedures = @property.procedures
  end

  # GET /properties/new
  def new
    @property = defaultize(Property.new({ostatus: params[:ostatus]}))
    @property.lease_base_rent = @property.current_rent
    # @property.ostatus = params["ostatus"]
    @property.check_price_current_rent_cap_rate
    add_breadcrumb ("<div class=\"pull-left\"><h4><a href=\'" + new_property_path(ostatus: params["ostatus"]) +
      "\'> Add Property - " + params["ostatus"] + " </a></h4></div>").html_safe
    render layout: false if request.xhr?
  end

  # GET /properties/1/edit
  def edit
    @property.ostatus = @property.ownership_status

    @latLng = @property.latLng
    if !@latLng.nil?
      @latitude = @latLng[0]
      @longitude = @latLng[1]
    end

    if !(@property.owner_person_is.nil? || @property.owner_person_is==0)
      @property.owner_entity_id_indv = @property.owner_entity_id if @property.owner_person_is == 1
    else
      @property.owner_entity_id = @property.owner_entity_id_indv = 0
    end
    add_breadcrumb ("<div class=\"pull-left\"><h4><a href=\'" + edit_property_path(@property.key) +
      "\'> Edit " + @property.ownership_status + " Property - " + @property.title + " </a></h4></div>").html_safe
    render layout: false if request.xhr?
  end

  # POST /properties
  # POST /properties.json
  def create
    @property         = Property.new(property_params)
    @property.rent_table_version = 0
    @property.lease_base_rent = @property.current_rent
    @property.user_id = current_user.id
    if !(@property.owner_person_is.nil? || @property.owner_person_is==0)
      @property.owner_entity_id = @property.owner_entity_id_indv if @property.owner_person_is == 1
    else
      @property.owner_entity_id = @property.owner_entity_id_indv = 0
    end
    respond_to do |format|
      if @property.save
        AccessResource.add_access({ user: current_user, resource: @property })
        flash[:success] = "New Property Successfully Created.</br><a href='#{properties_path(active_id: @property.id)}'>Show in List</a>" if !request.xhr?
        format.html { redirect_to edit_property_path(@property.key, type_is: 'basic_info') }
        # format.html { redirect_to properties_path }
        format.js { render json: @property.to_json, status: :ok }
        format.json { render action: 'show', status: :created, location: @property }
      else
        flash[:error] = "Failed to create new property."
        format.html { render action: 'new' }
        format.js { render action: 'new', status: :unprocessable_entity, layout: false }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /properties/1
  # PATCH/PUT /properties/1.json
  def update
    @property = Property.find(params[:id])

    if params[:type_is] == "photo_gallery"
      #Cover Image Save
      if params["property"]["prop_cover_img"]
        @property_cover_img = @property.property_cover_image.present? ? @property.property_cover_image : @property.build_property_cover_image
        @property_cover_img.upload_image(params["property"]["prop_cover_img"])
      end

      #Other images
      if params["property"]["prop_imgs"]
        params["property"]["prop_imgs"].each do |img|
          @property.property_images.new.upload_image(img) if img
        end
      end

      respond_to do |format|
        flash[:success] = "New Images Successfully Uploaded.</br><a href='#{properties_path(active_id: @property.id)}'>Show in List</a>"
        format.html { redirect_to edit_property_path(@property.key, type_is: params[:type_is]) }
        format.json { render action: 'show', status: :created, location: @property }
      end
    else
      @property.assign_attributes(property_params)
      @property.lease_base_rent = @property.current_rent

      if !(@property.owner_person_is.nil? || @property.owner_person_is==0)
        @property.owner_entity_id = @property.owner_entity_id_indv if @property.owner_person_is == 1
      else
        @property.owner_entity_id = @property.owner_entity_id_indv = 0
      end

      if @property.rent_table_version.nil?
        @property.rent_table_version = 1
      else
        @property.rent_table_version = @property.rent_table_version + 1
      end

      respond_to do |format|
        if @property.save

          # finally remove the old upload
          # Cloudinary::Uploader.destroy(public_id) unless public_id.blank?

          if @property.can_create_rent_table?
            rent_table_version = @property.rent_table_version

            base_rent = @property.lease_base_rent
            duration = @property.lease_duration_in_years
            percentage = @property.lease_rent_increase_percentage
            slab = @property.lease_rent_slab_in_years

            rent = base_rent
            @property.rent_tables.create(version: rent_table_version, rent: base_rent, description: 'Base Annual Rent')
            @property.rent_tables.create(version: rent_table_version, rent: base_rent / 12.00, description: 'Base Monthly Rent (approx.)')
            @property.rent_tables.create(version: rent_table_version, rent: base_rent/ 365.00, description: 'Base Daily Rent (approx.)')
            prev_rent = rent
            rent_start = @property.rent_commencement_date || Time.now
            rent_start = Time.now if @property.rent_commencement_date_details == 'Date not certain'
            start_year = rent_start.year
            end_year = 0

            count = 0

            if @property.lease_is_pro_rated && @property.rent_commencement_date_details != 'Date not certain'
              d = rent_start

              # 0 fill in the pro rated fields for the property and save
              @property.pro_rated_month = d.month
              @property.pro_rated_month_name = Date::MONTHNAMES[d.month]
              @property.pro_rated_day = d.day
              @property.pro_rated_year = d.year
              @property.pro_rated_day_date = d.to_date
              @property.pro_rated_day_rent = (base_rent / 365.00)
              @property.pro_rated_month_rent = (base_rent / 12.00) - ((d.day - 1) * @property.pro_rated_day_rent)
              @property.save

              @property.rent_tables.create(version: rent_table_version, rent: @property.pro_rated_month_rent,
                description: "Pro-rated Rent for :#{Date::MONTHNAMES[d.month]} #{d.year}")

              # 1 - calculate the pro-rated rent for year 1
              rent_first_year = rent * (((Date.parse("31/12/#{d.year}") - d.to_date).to_i) * 1.00/(d.year % 4 == 0 ? 366.00 : 365.00))
              # 2 - add the rent table entry
              @property.rent_tables.create(version: rent_table_version, start_year: d.year, end_year: d.year, rent: rent_first_year)
              # 3 - decrease the duration by 1 and update rent
              duration = duration - 1
              start_year = d.year + 1
              count = slab - 1
              slab = slab - 1
            end


            while start_year <= rent_start.year + duration - 1
              if count == 0
                slab = @property.lease_rent_slab_in_years
              else
                count = 0
              end
              end_year = start_year + slab - 1

              if end_year >= rent_start.year + duration - 1
                end_year = rent_start.year + duration - 1
              end

              prev_rent = rent
              @property.rent_tables.create(version: rent_table_version, start_year: start_year, end_year: end_year, rent: rent)

              start_year = end_year + 1
              rent = rent + rent * percentage / 100
            end

            if @property.number_of_option_period && @property.length_of_option_period &&
                @property.number_of_option_period > 0 && @property.length_of_option_period > 0
              duration = @property.number_of_option_period * @property.length_of_option_period
              start_year = end_year + 1
              rent_start = Date.parse("01/01/#{start_year}")
              rent = prev_rent
              slab = @property.length_of_option_period
              count = 1
               while start_year <= rent_start.year + duration - 1
                end_year = start_year + slab - 1

                if end_year >= rent_start.year + duration - 1
                  end_year = rent_start.year + duration - 1
                end

                prev_rent = rent
                @property.rent_tables.create(version: rent_table_version,
                  start_year: start_year, end_year: end_year, rent: rent,
                  is_option: true, option_slab: count)

                start_year = end_year + 1
                rent = rent + rent * percentage / 100
                count = count + 1
              end
            end

          end

          flash[:success] = "The Property Successfully Updated.</br><a href='#{properties_path(active_id: @property.id)}'>Show in List</a>"

          if params[:lease_sub].blank?
            format.html { redirect_to edit_property_path(@property.key, type_is: params[:type_is]) }
          else
            format.html { redirect_to edit_property_path(@property.key, type_is: params[:type_is], lease_sub: params[:lease_sub]) }
          end
          format.js { render json: @property.to_json, status: :ok }
          format.json { render action: 'show', status: :created, location: @property }
        else
          format.html { render action: 'edit' }
          format.json { render json: @property.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.json
  def destroy
    @property.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def member
    @action = Procedure::Action.find_by(key: params[:id])
    if request.post?
      email = params[:email]
      if email.email?
        user = User.find_by(email: email)
        user ||= Users::Unregistered.find_or_create_by(email: email)
        if user.class.to_s == 'User'
          access_resource = AccessResource.find_or_create_by(resource_id: @action.id, resource_klass: @action.class.to_s, user_id: user.id)
        else
          access_resource = AccessResource.find_or_create_by(resource_id: @action.id, resource_klass: @action.class.to_s, unregistered_u_k: user.key)
        end
        access_resource.permission_type = params[:permission_type]
        access_resource.can_access      = (user.class.to_s == 'User')
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

  def multi_delete
    common_multi_delete
  end

  def xhr_list_dropdown
    @property = Property.find_by(id: params[:id])
    if params[:person] == "true"
      @klass = "Person"
      @entities =  @property.ownership_person_dropdown
    else
      @entities =  @property.ownership_entity_dropdown
    end

    render layout: false
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_property
    @property = Property.find_by(key: params[:id])
    raise ActiveRecord::RecordNotFound if @property.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def property_params
    params.require(:property).permit!
  end

  def current_page
    @current_page = 'property'
  end

  def add_breadcrum
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/properties\">Properties </a></h4></div>".html_safe
    if params[:action] == "edit"
      if params[:type_is] == 'county_tax'
        add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/properties\"> County Tax </a></h4></div>".html_safe
      elsif params[:type_is] == 'tenant'
        add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/properties\"> Tenant </a></h4></div>".html_safe
      elsif params[:type_is] == 'lease'
        add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/properties\"> Lease </a></h4></div>".html_safe
      elsif params[:type_is] == 'ownership'
        add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/properties\"> Ownership </a></h4></div>".html_safe
      else
        #add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/properties\"> Basic Info </a></h4></div>".html_safe
      end
    end

  end

  def validate_ipp
    exchangor = Entity.where(id: AccessResource.get_ids({user: current_user, resource_klass: 'Entity'})).first
    replacement_seller =  Contact.where(contact_type: 'Counter-Party', user_id: current_user.id).first
    if !exchangor.present? && !replacement_seller.present?
      return redirect_to '/initial-participants'
    end

    if params[:ostatus] == 'Purchased'
      if exchangor.present?
        #allow user goes to property
      else
        # not created relinquishing seller
        return redirect_to '/initial-participants'
      end
    elsif params[:ostatus] == 'Prospective Purchase'
      if replacement_seller.present?
        #allow user goes to property
      else
        # not created property owner
        return redirect_to '/initial-participants'
      end
    end

  end
end
