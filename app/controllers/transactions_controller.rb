class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy, :edit_qualified_intermediary,
                                         :qualified_intermediary, :properties_edit, :properties_update,
                                         :terms, :terms_update, :inspection, :closing, :personnel,
                                         :personnel_update, :get_status, :set_status, :qi_status, :inspection_update]
  before_action :current_page
  before_action :add_breadcrum, only: [:index]
  # GET /project
  # GET /project.json

  layout 'transaction', except: [:index]

  include TransactionsHelper

  def index
    params[:mode] = user_session['worked_on'] || 'sale' if params[:mode].nil?
    klazz         = (params[:mode] == 'buy') ? 'TransactionPurchase' : 'TransactionSale'
    @transactions = klazz.constantize.with_deleted.joins(:transaction_main)
    @transactions = @transactions.where('transaction_mains.init' => false, 'transaction_mains.user_id' => current_user.id)
    @transactions = @transactions.where('transactions.deleted_at' => nil) unless params[:trashed].to_b
    @transactions = @transactions.where.not('transactions.deleted_at' => nil) if params[:trashed].to_b
    del_transaction_ids = []
    if params[:mode] == 'sale'
      # filter out the transaction which have a closed property
      # @transactions.each do |transaction|
      #   tprops = transaction.transaction_properties
      #   del_flag = false
      #   tprops.each do |prop|
      #     if prop.closed?
      #       del_flag = true
      #       break
      #     end
      #   end
      #   del_transaction_ids << transaction.id if del_flag
      # end
    elsif params[:mode] == 'buy'
      # check for 'already sold' transactions beacuse created_at <
      # created_at for a complimentary sale transaction else
      # check for the sale closure
      @transactions.each do |transaction|
        main = transaction.main
        sale = main.sale
        if !sale.nil?
          if transaction.created_at > sale.created_at
            tprops = sale.transaction_properties
            del_flag = true
            tprops.each do |prop|

              if prop.closed?
                del_flag = false
                break
              end

            end
            del_transaction_ids << transaction.id if del_flag
          end
        end

      end
    end
    @transactions = @transactions.where.not('transactions.id in (?)', del_transaction_ids) if del_transaction_ids.count > 0
    @transactions = @transactions.order('transactions.updated_at DESC, transactions.created_at DESC').paginate(page: params[:page], per_page: sessioned_per_page)
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/transactions\">List </a></h4></div>".html_safe
  end

  # GET /project/1
  # GET /project/1.json
  def show
    @properties = @transaction.properties.order(id: :asc)
  end

  # GET /project/new
  def new
    if params[:transaction_type] == '1031 Still Selling' || params[:type] == 'purchase'

      @transaction_main = TransactionMain.find_by(id: params[:main_id]) || TransactionMain.create(user_id: current_user.id, init: true)

      @transaction = if params[:type] == 'purchase'
                       t = TransactionSale.where(transaction_main_id: @transaction_main.id).first ||
                        TransactionSale.new(transaction_main_id: @transaction_main.id)
                       t1 = TransactionPurchase.new({
                         transaction_main_id: @transaction_main.id,
                         relinquishing_seller_entity_id: t.relinquishing_seller_entity_id,
                         relinquishing_seller_honorific: t.relinquishing_seller_honorific,
                         relinquishing_seller_first_name: t.relinquishing_seller_first_name,
                         relinquishing_seller_last_name: t.relinquishing_purchaser_last_name,

                         replacement_purchaser_entity_id: t.replacement_purchaser_entity_id,
                         replacement_purchaser_honorific: t.replacement_purchaser_honorific,
                         replacement_purchaser_first_name: t.replacement_seller_first_name,
                         replacement_purchaser_last_name: t.replacement_purchaser_last_name,
                         purchaser_person_is: t.seller_person_is
                       })
                       t1.save
                       t1
                     else
                       params[:type] = 'sale'
                      #  ts = defaultize TransactionSale.new
                      #  entity_ = Entity.find(ts.relinquishing_seller_entity_id)
                      #  if entity_.type_ == 1 or entity_.type_ == 4
                      #    ts.seller_person_is = true
                      #    ts.relqn_seller_entity_id = ts.relinquishing_seller_entity_id
                      #  elsif entity_.type_ > 4
                      #    ts.seller_person_is = false
                      #  elsif entity_.type_ == 2
                      #    if entity_.name2.nil? || entity_.name2.blank?
                      #      ts.seller_person_is = true
                      #      ts.relqn_seller_entity_id = ts.relinquishing_seller_entity_id
                      #    else
                      #      ts.seller_person_is = false
                      #    end
                      #   elsif entity_.type_ == 4
                      #     p = Principal.where(entity_id: ts.relinquishing_seller_entity_id)
                      #     if p.is_person
                      #       ts.seller_person_is = true
                      #       ts.relqn_seller_entity_id = ts.relinquishing_seller_entity_id
                      #     else
                      #       ts.seller_person_is = false
                      #     end
                      #  end
                      #  ts.transaction_main_id = @transaction_main.id
                      #  ts
                       TransactionSale.new(transaction_main_id: @transaction_main.id) #,
                      #  relinquishing_seller_entity_id: ts.relinquishing_seller_entity_id)
                     end

      @transaction.is_purchase = (params[:type] == 'sale' || params[:type].blank?) ? 0 : 1
      @transaction.prop_owner = @transaction.replacement_seller_contact_id || 0
      @transaction.prop_status = "Prospective Purchase"

      # if @transaction.transaction_properties.blank?
      #   @transaction.transaction_properties.build
      # end
    elsif params[:transaction_type] == '1031 Already Sold'
      @transaction_main        = TransactionMain.create(user_id: current_user.id, init: true, purchase_only: true)
      @transaction             = TransactionPurchase.new(transaction_main_id: @transaction_main.id)
      @transaction.is_purchase = 1
    elsif params[:type] == 'sale' && params[:main_id].present?
      @transaction_main        = TransactionMain.find_by(id: params[:main_id])
      t = TransactionPurchase.where(transaction_main_id: @transaction_main.id).first ||
        TransactionPurchase.new(transaction_main_id: @transaction_main.id)
      @transaction = TransactionSale.new({
        transaction_main_id: @transaction_main.id,
        relinquishing_seller_entity_id: t.relinquishing_seller_entity_id,
        relinquishing_seller_honorific: t.relinquishing_seller_honorific,
        relinquishing_seller_first_name: t.relinquishing_seller_first_name,
        relinquishing_seller_last_name: t.relinquishing_purchaser_last_name,
        replacement_purchaser_entity_id: t.replacement_purchaser_entity_id,
        replacement_purchaser_honorific: t.replacement_purchaser_honorific,
        replacement_purchaser_first_name: t.replacement_seller_first_name,
        replacement_purchaser_last_name: t.replacement_purchaser_last_name,
        seller_person_is: t.purchaser_person_is
      })
      @transaction.save
      @transaction.is_purchase = 0
    end
    params[:main_id] = @transaction_main.id
    build_gallery_transaction_properties @transaction, params[:type]
    if params[:type] == 'purchase'
      @transaction.transaction_baskets.build
    end

  end

  # GET /project/1/edit
  def edit
    if params["type"] == "sale"
      if params[:where] == "list"
        redirect_to_saved_step
      end
      @transaction.relqn_seller_entity_id = @transaction.relinquishing_seller_entity_id if @transaction.seller_person_is
      @transaction.relqn_purchaser_contact_id = @transaction.relinquishing_purchaser_contact_id if @transaction.purchaser_person_is
    else
      @transaction.rplmnt_seller_contact_id = @transaction.replacement_seller_contact_id if @transaction.seller_person_is
      @transaction.rplmnt_purchaser_entity_id = @transaction.replacement_purchaser_entity_id if @transaction.purchaser_person_is

      if params[:cur_property].blank?
        @property = get_transaction_properties(@transaction).first
      else
        @property = Property.find(params[:cur_property])
      end

      if @property.present?
        params[:cur_property] = @property.id.to_s
      else
        params[:cur_property] = ""
        redirect_to properties_edit_transaction_path(@transaction, sub: 'property', type: params[:type], main_id: params[:main_id])
        return
      end

      @transaction_property = @transaction.transaction_properties.where(property_id: @property.id).first
      @sub_tab = params[:sub_tab] || @transaction_property.current_step_subtab
    end

  end

  # GET /Transaction/1/properties_edit
  def properties_edit
    if params["type"] == "sale"
      @transaction.prop_owner = @transaction.relinquishing_seller_entity_id || 0
      @transaction.prop_status = "Purchased"
    else
      if params[:where] == "list"
        redirect_to_saved_step
      end
      @transaction.prop_owner = @transaction.replacement_seller_contact_id || 0
      @transaction.prop_status = "Prospective Purchase"
    end
    # if @transaction.transaction_properties.blank?
    #   @transaction.transaction_properties.build
    # end
    if params[:type] == 'purchase'
      if @transaction.transaction_baskets.blank?
        @transaction.transaction_baskets.build
      end
    end
    @transaction.entity_info = @transaction.seller_name || @transaction.purchaser_name
    # @transaction.transaction_properties.build
    build_gallery_transaction_properties @transaction, params[:type]
  end

  # GET /Transaction/1/properties_update
  def properties_update
    flag = false
    p_count = @transaction.transaction_properties.length

    # (0..p_count-1).each do |p_index|
    #   pid = params[:transaction][:transaction_properties_attributes]["#{p_index}".to_sym][:property_id]

    #   if !(params["type"]).nil? && params["type"] == "purchase" && @transaction.replacement_seller_contact_id.nil?
    #     property = Property.where(id: pid).first
    #     if !property.owner_entity_id.nil?
    #       contact = Contact.where(id: property.owner_entity_id).first
    #       @transaction.replacement_seller_contact_id = contact.id
    #       @transaction.replacement_seller_first_name = contact.company_name || contact.first_name
    #       @transaction.replacement_seller_last_name = contact.last_name
    #       flag = true
    #     end
    #   end
    # end

    begin
      TransactionSale.transaction do
        @transaction.save! if flag
        
        if params[:type] == 'sale'
          @transaction.update!(transaction_property_params)
        else
          if params[:identification_rule] == '200_percent'
            # if params[:basket_id].present?
            #   basket = @transaction.transaction_baskets.find(params[:basket_id])
            #   if basket.present?
            #     @basket_properties = basket.transaction_basket_properties.pluck(:property_id)
            #   else
            #     @basket_properties = []
            #   end
            # else
            #   @basket_properties = []
            # end
            
            @cur_transaction_property = @transaction.transaction_properties.where(:property_id => params[:cur_property]).first
            if @cur_transaction_property.present?
              @cur_transaction_property.transaction_property_offers.destroy_all
              if params[:initial_asking_price]["#{@cur_transaction_property.property_id}".to_sym] == "1"
                @cur_transaction_property.transaction_property_offers.create([:offer_name => "Seller", :is_accepted => true, :accepted_counteroffer_id => 0])
              else
                @transaction_property_offer = @cur_transaction_property.transaction_property_offers.create(:offer_name => "Seller", :is_accepted => false)
                @transaction_property_offer.counteroffers.create(offered_date: Time.now.strftime('%Y-%m-%d'), offer_type: 'Counter-Party', offered_price: params[:counter_price]["#{@cur_transaction_property.property_id}".to_sym])
              end
            end

          else
            @transaction.update!(transaction_property_params)
            @transaction.transaction_properties.each do |transaction_property|
              if params[:initial_asking_price]["#{transaction_property.property_id}".to_sym] == "1" && transaction_property.is_selected
                if transaction_property.transaction_property_offers.destroy_all
                  transaction_property.transaction_property_offers.create([:offer_name => "Seller", :is_accepted => true, :transaction_property_id => transaction_property.id, :accepted_counteroffer_id => 0])
                end
              end
            end
          end
        end
      end

      #return redirect_to personnel_transaction_path(@transaction, sub: 'personnel', type: params[:type], main_id: params[:main_id])
      if @transaction.get_sale_purchase_text == 'sale'
        return redirect_to terms_transaction_path(@transaction, sub: 'terms', type: @transaction.get_sale_purchase_text, main_id: @transaction_main.id)
      else
        return redirect_to terms_transaction_path(@transaction, sub: 'terms', type: @transaction.get_sale_purchase_text, main_id: @transaction_main.id, cur_property: params[:cur_property])
      end

    rescue Exception => e
     #render action: :properties_edit
     @transaction.errors.add(:base, "Could not complete the action. Verify the data and try again.")
     redirect_to properties_edit_transaction_path(@transaction, sub: 'property', type: @transaction.get_sale_purchase_text, main_id: @transaction_main.id)
    end

  end

  # POST /project
  # POST /project.json
  def create
    @transaction         = params[:transaction_klazz].constantize.new(transaction_params)
    @transaction_main    = @transaction.transaction_main
    @transaction.user_id = current_user.id
    @ct = nil
    @ct = fix_transaction
    cflag = true
    respond_to do |format|
      if !@ct.nil?
        cflag = @ct.save
      end
      if @transaction.save && cflag
        AccessResource.add_access({ user: current_user, resource: @transaction })
        @transaction.transaction_main.update_column(:init, false)
        # format.html { redirect_to edit_transaction_path(@transaction, type: @transaction.get_sale_purchase_text, main_id: @transaction.transaction_main, status_alert: (CGI.escape(params[:status_alert]) rescue nil)), notice: 'Transaction was successfully created.' }
        format.html { redirect_to properties_edit_transaction_path(@transaction, sub: 'property', type: @transaction.get_sale_purchase_text, main_id: @transaction_main.id, status_alert: (CGI.escape(params[:status_alert]) rescue nil)), notice: 'Transaction was successfully created.' }
        format.json { render action: 'show', status: :created, location: @transaction }
      else
        format.html { render action: 'new' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project/1
  # PATCH/PUT /project/1.json
  def update
    @transaction = params[:transaction_klazz].constantize.find(params[:id])
    @transaction.assign_attributes(transaction_params)
    @ct = nil
    @ct = fix_transaction
    cflag = true
    if !@ct.nil?
      cflag = @ct.save
    end
    if @transaction.save && cflag #update(transaction_params)
      if params[:type] == 'purchase'
        return redirect_to inspection_transaction_path(@transaction, sub: 'inspection', type: @transaction.get_sale_purchase_text, cur_property: params[:cur_property], main_id: params[:main_id])
      else
        return redirect_to properties_edit_transaction_path(@transaction, sub: 'property', type: @transaction.get_sale_purchase_text, main_id: @transaction_main.id, status_alert: (CGI.escape(params[:status_alert]) rescue nil))
      end
    else
      render action: :edit
    end
  end

  def fix_transaction
    purchase = params[:is_purchase] || "false"

    if purchase == "true"
      if @transaction.seller_person_is == false
        @transaction.replacement_seller_contact_id = @transaction.rplmnt_seller_contact_id
      end
      if @transaction.purchaser_person_is == false
        @transaction.replacement_purchaser_entity_id = @transaction.rplmnt_purchaser_entity_id
      end
      if @transaction.replacement_seller_contact_id
        seller = Contact.where(id: @transaction.replacement_seller_contact_id).first
        if seller
          @transaction.replacement_seller_first_name = seller.first_name
          @transaction.replacement_seller_last_name = seller.last_name
        end
      end
      if @transaction.replacement_purchaser_entity_id
        purchaser = Entity.where(id: @transaction.replacement_purchaser_entity_id).first
        if purchaser
          @transaction.replacement_purchaser_honorific = purchaser.honorific
          @transaction.replacement_purchaser_first_name = purchaser.first_name || purchaser.name
          @transaction.replacement_purchaser_last_name = purchaser.last_name
          # Mirror the replacement buyer to relinquishing seller
          @transaction.relinquishing_seller_entity_id = purchaser.id
          @transaction.relinquishing_seller_honorific = purchaser.honorific
          @transaction.relinquishing_seller_first_name = purchaser.first_name || purchaser.name
          @transaction.relinquishing_seller_last_name = purchaser.last_name
        end
      end
    else
      if @transaction.seller_person_is == false
        @transaction.relinquishing_seller_entity_id = @transaction.relqn_seller_entity_id
      end
      if @transaction.purchaser_person_is == false
        @transaction.relinquishing_purchaser_contact_id = @transaction.relqn_purchaser_contact_id
      end
      if @transaction.relinquishing_seller_entity_id
        seller = Entity.where(id: @transaction.relinquishing_seller_entity_id).first
        if !seller.nil?
          @transaction.relinquishing_seller_honorific = seller.honorific
          @transaction.relinquishing_seller_first_name = seller.first_name || seller.name
          @transaction.relinquishing_seller_last_name = seller.last_name
          # Mirror the relinquishing seller to replacement buyer
          @transaction.replacement_purchaser_entity_id = seller.id
          @transaction.replacement_purchaser_honorific = seller.honorific
          @transaction.replacement_purchaser_first_name = seller.first_name || seller.name
          @transaction.replacement_purchaser_last_name = seller.last_name
        end
      end
      if @transaction.relinquishing_purchaser_contact_id
        purchaser = Contact.where(id: @transaction.relinquishing_purchaser_contact_id).first
        if purchaser
          @transaction.relinquishing_purchaser_first_name = purchaser.first_name
          @transaction.relinquishing_purchaser_last_name = purchaser.last_name
        end
      end
    end

    if @transaction.is_a?(TransactionSale)
      @ct = TransactionPurchase.where(transaction_main_id: @transaction.transaction_main_id).first
      return nil if @ct.nil?
      @ct.replacement_purchaser_entity_id = @transaction.relinquishing_seller_entity_id
      @ct.purchaser_person_is = @transaction.seller_person_is
      @ct.replacement_purchaser_honorific = @transaction.relinquishing_seller_honorific
      @ct.replacement_purchaser_first_name = @transaction.relinquishing_seller_first_name
      @ct.replacement_purchaser_last_name = @transaction.relinquishing_seller_last_name
    else
      @ct = TransactionSale.where(transaction_main_id: @transaction.transaction_main_id).first
      return nil if @ct.nil?
      @ct.relinquishing_seller_entity_id = @transaction.replacement_purchaser_entity_id
      @ct.seller_person_is = @transaction.purchaser_person_is
      @ct.relinquishing_seller_honorific = @transaction.replacement_purchaser_honorific
      @ct.relinquishing_seller_first_name = @transaction.replacement_purchaser_first_name
      @ct.relinquishing_seller_last_name = @transaction.replacement_purchaser_last_name
    end
    return @ct
  end

  # DELETE /project/1
  # DELETE /project/1.json
  def destroy
    @transaction_main.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def settings
    @transaction = TransactionSale.find_by(key: params[:id])
    render layout: false
  end

  def edit_qualified_intermediary
    @qualified_intermediary = @transaction.qualified_intermediary
    @qualified_intermediary.wired_instruction
    @qualified_intermediary.contact
  end

  def qualified_intermediary
    @qualified_intermediary = @transaction.qualified_intermediary
    if @qualified_intermediary.update(qualified_intermediary_params)
      # redirect_to edit_qualified_intermediary_transaction_path(@transaction, sub: params[:sub], main_id: params[:main_id], type: params[:type])
      redirect_to properties_edit_transaction_path(@transaction, sub: 'property', type: params[:type], main_id: params[:main_id])
    else
      render action: :edit_qualified_intermediary
    end
  end

  def terms
    if params[:cur_property].blank?
      @property = get_transaction_properties(@transaction).first
    else
      @property = Property.find(params[:cur_property])
    end

    if @property.present?
      params[:cur_property] = @property.id.to_s
    else
      params[:cur_property] = ""
      redirect_to properties_edit_transaction_path(@transaction, sub: 'property', type: params[:type], main_id: params[:main_id])
      return
    end

    @transaction_property = @transaction.transaction_properties.where(property_id: @property.id).first
    if @transaction_property.present?
      if @transaction_property.transaction_term.blank?
        @transaction_property.build_transaction_term
        # set default values for transaction term
        defaultize @transaction_property.transaction_term
      end

      if params[:type] == 'sale'
        if ! @transaction_property.transaction_property_offers.present?
          @transaction_property.transaction_property_offers.create([:offer_name => "Offeror 1", :is_accepted => false, :transaction_property_id => @transaction_property.id])
        end
      else
        if ! @transaction_property.transaction_property_offers.present?
          @transaction_property.transaction_property_offers.create([:offer_name => "Seller", :is_accepted => false, :transaction_property_id => @transaction_property.id])
        end
      end

      @sub_tab = params[:sub_tab] || @transaction_property.current_step_subtab
    else
      redirect_to properties_edit_transaction_path(@transaction, sub: 'property', type: params[:type], main_id: params[:main_id])
    end

  end

  def inspection
    if params[:cur_property].blank?
      @property = get_transaction_properties(@transaction).first
    else
      @property = Property.find(params[:cur_property])
    end

    if @property.present?
      params[:cur_property] = @property.id.to_s
    else
      params[:cur_property] = ""
      redirect_to properties_edit_transaction_path(@transaction, sub: 'property', type: params[:type], main_id: params[:main_id])
      return
    end

    @transaction_property = @transaction.transaction_properties.where(property_id: @property.id).first
    @sub_tab = params[:sub_tab] || @transaction_property.current_step_subtab
    #coming soon

  end

  def inspection_update
    #coming soon
    @transaction_property = @transaction.transaction_properties.where(property_id: params[:cur_property]).first
    respond_to do |format|
      if params[:transaction]
        if @transaction_property.update(transaction_inspection_params)
          format.html {
            redirect_to closing_transaction_path(@transaction, sub: 'closing', type: 'purchase', cur_property: params[:cur_property], main_id: params[:main_id])
          }
          format.json { render json: true }
        else
        end
      else
        format.json { render json: true }
      end
    end
  end

  def closing
    if request.post?
      # Parameters: {"date"=>{"year"=>"2017", "month"=>"6", "day"=>"4"},
      # "closing_proceeds"=>"12121212.00", "main_id"=>"83", "cur_property"=>"16",
      # "commit"=>"Proceed to Close", "id"=>"31"}
      @transaction_property = TransactionProperty.where(property_id: params[:cur_property], transaction_id: params[:id]).first
      if @transaction_property.nil?
        # houston we have a problem
        @transaction.errors.add(:base, "Cannot close unknown property.")
      else
        prev_val = @transaction_property.closing_proceeds || 0
        d = params[:date]
        @transaction_property.closing_date = Date.new(d["year"].to_i,d["month"].to_i,d["day"].to_i)
        @transaction_property.closing_proceeds = params[:closing_proceeds]
        @transaction_property.save

        if @transaction.main.identification_deadline.nil? ||
            ((@transaction.main.identification_deadline + 45.days) < (@transaction_property.closing_date + 45.days))
            @transaction.main.identification_deadline = @transaction_property.closing_date + 45.days
        end
        if @transaction.main.transaction_deadline.nil? ||
            ((@transaction.main.transaction_deadline + 180.days) < (@transaction_property.closing_date + 180.days))
            @transaction.main.transaction_deadline = @transaction_property.closing_date + 180.days
        end

        has_deadline_passed = false
        has_deadline_passed =
          DateTime.now > @transaction.main.transaction_deadline if !@transaction.main.transaction_deadline.nil?

        if has_deadline_passed
          # deadline has elapsed - into boot you go
          @transaction.main.boot = @transaction.main.boot +
            @transaction.main.qi_funds
          @transaction.main.qi_funds = 0
          # if it is a sale add it to boot
          @transaction.main.boot = @transaction.main.boot +
            @transaction_property.closing_proceeds if @transaction.is_a?(TransactionSale)
        else
          # still within the 180 days deadline
          val = @transaction.main.qi_funds
          if @transaction.is_a?(TransactionSale)
            val = val - prev_val + @transaction_property.closing_proceeds
          else
            val = val + prev_val - @transaction_property.closing_proceeds
          end
          @transaction.main.qi_funds = val
        end

        @transaction.main.save
        if @transaction.is_a?(TransactionSale)
          if @transaction.main.purchase.nil?
            t = @transaction
            t1 = TransactionPurchase.new({
              transaction_main_id: @transaction.main.id,
              relinquishing_seller_entity_id: t.relinquishing_seller_entity_id,
              relinquishing_seller_honorific: t.relinquishing_seller_honorific,
              relinquishing_seller_first_name: t.relinquishing_seller_first_name,
              relinquishing_seller_last_name: t.relinquishing_purchaser_last_name,
              replacement_purchaser_entity_id: t.replacement_purchaser_entity_id,
              replacement_purchaser_honorific: t.replacement_purchaser_honorific,
              replacement_purchaser_first_name: t.replacement_seller_first_name,
              replacement_purchaser_last_name: t.replacement_purchaser_last_name,
              purchaser_person_is: t.seller_person_is
            })
            t1.is_purchase = 1
            t1.save
          end
        end

      end
      #return redirect_to edit_transaction_path(@transaction, type: 'sale', main_id: @transaction.transaction_main_id)
      unless params[:type] == "purchase" || @transaction_property.nil?
        flash[:success] = "Congratulations on your sale of <b>#{Property.find(@transaction_property.property_id).name}</b> to <b>#{@transaction.relinquishing_seller_entity.display_name}</b>. <b>#{ActionController::Base.helpers.number_to_currency(@transaction_property.closing_proceeds)}</b> is being transferred to your Qualified Intermediary. <b>#{Property.find(@transaction_property.property_id).name}</b> is now being reclassified from a Purchased Property to a Sold Property. Please proceed to the Purchase Module as you only have 45 days to identify one or more Replacement Properties to Buy. It might be a good idea to go to your Account Settings so that you can receive warning alerts by email, SMS message or both."
        @transaction_property.property.update_attribute("ownership_status", "Sold")
      else
        @transaction_property.property.update_attribute("ownership_status", "Purchased") unless @transaction_property.nil?
      end
      return redirect_to qi_status_transaction_path(@transaction, main_id: @transaction.main.id)
    elsif request.get?
      # Parameters: {"cur_property"=>"16", "main_id"=>"83", "sub"=>"closing", "type"=>"sale", "id"=>"31"}
      @property_id = params[:cur_property]
      @transaction_id = params[:id]
      @transaction_main_id = params[:main_id]
      @transaction_property = TransactionProperty.where(property_id: @property_id, transaction_id: @transaction_id).first
      @transaction_property = TransactionProperty.where(transaction_id: @transaction_id).first if @transaction_property.nil?
      if @transaction_property.nil?
        # houston we have a problem
        @transaction.errors.add(:base, "Cannot close unknown property.")
        return redirect_to edit_transaction_path(@transaction, type: 'sale', main_id: @transaction.transaction_main_id)
      end
      @closing_date = @transaction_property.closing_date || Date.today
      @closing_proceeds = @transaction_property.closing_proceeds || 0
      @closed = @transaction_property.closed?
    end

  end

  def qi_status
    @transaction_main_id = params[:main_id]
    @transaction_main = TransactionMain.find(@transaction_main_id)
    if @transaction_main.nil?
      # big problem
    end
    params[:sub] = 'closing'
    params[:type] = 'qi_status'
    @tproperties = TransactionProperty.where(transaction_main_id: @transaction_main.id, is_selected: true)
    @sales = []
    @purchases = []
    @tproperties.each do |prop|
      if prop.is_sale
        @sales << prop
      else
        @purchases << prop
      end
    end
  end

  def terms_update
    @transaction_property = @transaction.transaction_properties.where(property_id: params[:cur_property]).first
    respond_to do |format|
      if @transaction_property.update(transaction_terms_params)
        format.html {
          # redirect_to terms_transaction_path(@transaction, sub: params[:sub], main_id: params[:main_id], type: params[:type])
          redirect_to edit_qualified_intermediary_transaction_path(@transaction, sub: 'qi', type: params[:type], main_id: params[:main_id])
        }
        format.json { render json: @transaction_property.transaction_term }
      else
        format.html {render action: :terms}
        format.json { render json: @transaction_property.errors.full_messages }
      end
    end
  end

  def personnel
    if @transaction.transaction_personnel.blank?
      @transaction.create_transaction_personnel
    end
    #@transaction.transaction_personnel.create_contacts
    @transaction_personnel = @transaction.transaction_personnel
  end

  def personnel_update
    @transaction_personnel = @transaction.transaction_personnel
    if @transaction.transaction_personnel.update(transaction_personnels_params)
      if TransactionPersonnel::FIXED_TITLE.find_next(params[:sub_sub] || TransactionPersonnel::FIXED_TITLE.first)
        redirect_to personnel_transaction_path(@transaction, sub: params[:sub], sub_sub: TransactionPersonnel::FIXED_TITLE.find_next(params[:sub_sub] || TransactionPersonnel::FIXED_TITLE.first), main_id: params[:main_id], type: params[:type])
      else
        redirect_to personnel_transaction_path(@transaction, sub: params[:sub], sub_sub: TransactionPersonnel::FIXED_TITLE.last, main_id: params[:main_id], type: params[:type])
      end
    else
      render action: :personnel
    end
  end

  def get_status

  end

  def set_status
    if @transaction_main.update(transaction_main_params)
      redirect_to get_status_transaction_path(@transaction_main, main_id: params[:main_id], type: params[:type])
    else
      render action: :get_status
    end
  end

  def multi_delete
    common_multi_delete
  end

  def delete_transaction_property
    tran_prop_id = params[:property_id]
    @transaction_main = TransactionMain.find(params[:main_id])

    if params[:type].blank? || params[:type] == 'sale'
      @transaction = @transaction_main.sale
    else
      @transaction = @transaction_main.purchase
    end

    if @transaction.transaction_properties.where(property_id: tran_prop_id).where(is_selected: true).destroy_all
      if @transaction.transaction_properties.where(is_selected: true).count > 0
        redirect_to terms_transaction_path(@transaction, sub: 'terms', type: @transaction.get_sale_purchase_text, main_id: @transaction_main.id)
      else
        redirect_to properties_edit_transaction_path(@transaction, sub: 'property', type: @transaction.get_sale_purchase_text, main_id: @transaction_main.id)
      end
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction_main = TransactionMain.find(params[:main_id])
    for_sale_or_purchase_tab

    save_current_step_state
  end

  def for_sale_or_purchase_tab
    if params[:type].blank? || params[:type] == 'sale'
      @transaction = @transaction_main.sale
      user_session['worked_on'] = 'sale'
    else
      @transaction = @transaction_main.purchase
      user_session['worked_on'] = 'buy'
    end
  end

  def save_current_step_state
    if params[:cur_property]
      if params[:type] == 'sale'
        TransactionProperty.where(property_id: params[:cur_property]).where(transaction_main_id: params[:main_id]).where(is_sale: true).update(current_step: params[:sub])
        # For sub tabs
        if params[:sub] == "terms"
          TransactionProperty.where(property_id: params[:cur_property]).where(transaction_main_id: params[:main_id]).where(is_sale: true).update(current_step_subtab: 'offer_and_acceptance')
        elsif params[:sub] == "inspection"
          TransactionProperty.where(property_id: params[:cur_property]).where(transaction_main_id: params[:main_id]).where(is_sale: true).update(current_step_subtab: 'seller_documentation')
        end
      else
        TransactionProperty.where(property_id: params[:cur_property]).where(transaction_main_id: params[:main_id]).where(is_sale: false).update(current_step: params[:sub])
        #For sub tabs
        if params[:sub] == "terms"
          TransactionProperty.where(property_id: params[:cur_property]).where(transaction_main_id: params[:main_id]).where(is_sale: false).update(current_step_subtab: 'offer_and_acceptance')
        elsif params[:sub] == "inspection"
          TransactionProperty.where(property_id: params[:cur_property]).where(transaction_main_id: params[:main_id]).where(is_sale: false).update(current_step_subtab: 'seller_documentation')
        elsif params[:sub] == "parties"
          TransactionProperty.where(property_id: params[:cur_property]).where(transaction_main_id: params[:main_id]).where(is_sale: false).update(current_step_subtab: 'basic_info')
        end
      end
    end
  end

  def redirect_to_saved_step
    if params[:type] == 'purchase'
      if params[:sub]
        case params[:sub]
        when 'property'
          redirect_to properties_edit_transaction_path(TransactionPurchase.find(params[:id]), sub: params[:sub], type: 'purchase', main_id: params[:main_id])
        when 'terms'
          if params[:sub_tab].present?
            redirect_to terms_transaction_path(TransactionPurchase.find(params[:id]), sub: params[:sub], type: 'purchase', main_id: params[:main_id], cur_property: params[:cur_property], sub_tab: params[:sub_tab])
          else
            redirect_to terms_transaction_path(TransactionPurchase.find(params[:id]), sub: params[:sub], type: 'purchase', main_id: params[:main_id], cur_property: params[:cur_property])
          end
        when 'parties'
          if params[:sub_tab].present?
            redirect_to edit_transaction_path(TransactionPurchase.find(params[:id]), type: 'purchase', main_id: params[:main_id], sub: params[:sub], cur_property: params[:cur_property], sub_tab: params[:sub_tab])
          else
            redirect_to edit_transaction_path(TransactionPurchase.find(params[:id]), type: 'purchase', main_id: params[:main_id], sub: params[:sub], cur_property: params[:cur_property])
          end
        when 'inspection'
          if params[:sub_tab].present?
            redirect_to inspection_transaction_path(TransactionPurchase.find(params[:id]), sub: params[:sub], type: 'purchase', main_id: params[:main_id], cur_property: params[:cur_property], sub_tab: params[:sub_tab])
          else
            redirect_to inspection_transaction_path(TransactionPurchase.find(params[:id]), sub: params[:sub], type: 'purchase', main_id: params[:main_id], cur_property: params[:cur_property])
          end
        when 'closing'
          redirect_to closing_transaction_path(TransactionPurchase.find(params[:id]), sub: params[:sub], type: 'purchase', main_id: params[:main_id], cur_property: params[:cur_property])
        else
          # To do
        end
      else
        # To do
      end
    else
      if params[:sub]
        case params[:sub]
        when 'property'
          redirect_to properties_edit_transaction_path(TransactionSale.find(params[:id]), sub: params[:sub], type: 'sale', main_id: params[:main_id])
        when 'terms'
          if params[:sub_tab].present?
            redirect_to terms_transaction_path(TransactionSale.find(params[:id]), sub: params[:sub], type: 'sale', main_id: params[:main_id], cur_property: params[:cur_property], sub_tab: params[:sub_tab])
          else
            redirect_to terms_transaction_path(TransactionSale.find(params[:id]), sub: params[:sub], type: 'sale', main_id: params[:main_id], cur_property: params[:cur_property])
          end
        when 'parties'
          redirect_to edit_transaction_path(TransactionSale.find(params[:id]), type: 'sale', main_id: params[:main_id], sub: params[:sub])
        when 'inspection'
          if params[:sub_tab].present?
            redirect_to inspection_transaction_path(TransactionSale.find(params[:id]), sub: params[:sub], type: 'sale', main_id: params[:main_id], cur_property: params[:cur_property], sub_tab: params[:sub_tab])
          else
            redirect_to inspection_transaction_path(TransactionSale.find(params[:id]), sub: params[:sub], type: 'sale', main_id: params[:main_id], cur_property: params[:cur_property])
          end
        when 'closing'
          redirect_to closing_transaction_path(TransactionSale.find(params[:id]), sub: params[:sub], type: 'sale', main_id: params[:main_id], cur_property: params[:cur_property])
        else
          # To do
        end
      else
        # To do
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transaction_params
    params.require(:transaction).permit!
  end

  def qualified_intermediary_params
    params.require(:qualified_intermediary).permit(:name, :currently_held, :price,
                                                   :premises_address, :city, :state, :country, :seller,
                                                   :seller_entity_type, :due_diligence_period, :wired_instruction_attributes => [:bank, :aba_no, :credit_to, :account_number, :reference, :id],
                                                   :contact_attributes                                                       => [:first_name, :last_name, :email, :zip, :fax, :street_address, :city, :state, :phone1, :phone2, :id])
  end

  def transaction_property_params
    params.require(:transaction).permit(transaction_properties_attributes: [:property_id, :sale_price, :id, :is_sale, :transaction_main_id, :_destroy, :cap_rate, :is_selected])
  end

  def transaction_terms_params
    params.require(:transaction).permit(transaction_term_attributes:
                                          [:id, :purchase_price, :current_annual_rent,
                                           :cap_rate, :psa_date, :m_psa_date,
                                           :first_deposit_date_due, :m_first_deposit_date_due,
                                           :first_deposit, :inspection_period_days,
                                           :end_of_inspection_period_note,
                                           :second_deposit, :second_deposit_amount,
                                           :closing_date, :m_closing_date, :transaction_id,
                                           :second_deposit_date_due, :m_second_deposit_date_due,
                                           :first_deposit_days_after_psa,
                                           :second_deposit_days_after_inspection_period,
                                           :closing_days_after_inspection_period, :closing_date_note])
  end

  def transaction_inspection_params
    params.require(:transaction).permit(:sale_inspection_lease_tasks_estoppel, :sale_inspection_lease_tasks_rofr, :purchase_inspection_lease_tasks_estoppel, :purchase_inspection_lease_tasks_rofr)
  end

  def transaction_personnels_params
    params.require(:transaction).permit(:contacts_attributes => [:first_name, :last_name, :email, :zip, :fax, :street_address, :city, :state, :phone1, :phone2, :id, :object_title])
  end

  def transaction_main_params
    params.require(:transaction_main).permit!
  end

  private
  def current_page
    @current_page = 'project'
  end

  def add_breadcrum
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/transactions\">Transactions </a></h4></div>".html_safe
  end

  def build_gallery_transaction_properties transaction, type
    if type == 'sale'
      possible_properties =
      Property.where('owner_entity_id = ? and ownership_status = ? and title is not null', transaction.prop_owner, transaction.prop_status)
    elsif type == 'purchase'
      possible_properties =
      Property.where('ownership_status = ? and title is not null', transaction.prop_status).where.not(price: nil)
    end

    existing_transaction_properties = transaction.transaction_properties.pluck(:property_id).uniq.compact

    possible_properties.each do |pp|
      unless existing_transaction_properties.include? pp.id
        type_ = type
        type_ = 'buy' if type == 'purchase'
        tp = defaultize TransactionProperty.new, type_
        transaction.transaction_properties.build( property_id: pp.id, is_sale: (type=='sale') ? true : false,
          transaction_main_id: transaction.transaction_main_id, cap_rate: tp.cap_rate, sale_price: tp.sale_price )
      end
    end
  end
end
