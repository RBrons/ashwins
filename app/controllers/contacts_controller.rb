class ContactsController < ApplicationController
  before_action :current_page

  def new
    @contact = Contact.new
    @contact.cprefix =  (params[:contact_type] == "company") ? "Contact " : ""
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/contacts\">Contacts </a></h4></div>".html_safe
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/contacts/new\">Add #{(params[:contact_type] || "contact").titleize} </a></h4></div>".html_safe
    render layout: false, template: "contacts/new" if request.xhr?
  end

  def create
    @contact = Contact.new(contact_params)
    params[:contact_type] = "company" if !@contact.company_name.nil?
    @contact.legal_ending = nil if @contact.company_name.nil?
    @contact.user_id = current_user.id
    @contact.cprefix =  (params[:contact_type] == "company") ? "Contact " : ""
    @contact.role = "Counter-Party"
    if @contact.contact_type == "Client Participant"
      @contact.role = @contact.cp_role
    elsif @contact.contact_type == "Personnel"
      @contact.role = @contact.per_role
    end
    
    respond_to do |format|
      if @contact.save
        if params[:from_relinquishing_offeror].present?
          if @contact.is_company
            TransactionPropertyOffer.find(params[:from_relinquishing_offeror]).update(offer_name: "#{@contact.company_name}")
          else
            TransactionPropertyOffer.find(params[:from_relinquishing_offeror]).update(offer_name: "#{@contact.first_name} #{@contact.last_name}")
          end
        end
        if params[:from_transaction_broker]
          transaction_property = TransactionProperty.find(params[:transaction_property_id])
          transaction_property.update(broker_id: @contact.id)
        elsif params[:from_transaction_attorney]
          transaction_property = TransactionProperty.find(params[:transaction_property_id])
          transaction_property.update(attorney_id: @contact.id)
        end

        flash[:success] = "New Contact Successfully Created.</br><a href='#{contacts_path(active_id: @contact.id)}'>Show in List</a>" if !request.xhr?
        format.html { redirect_to edit_contact_path(@contact) }
        # format.html { redirect_to contacts_path }
        format.js {render layout: false, template: "contacts/new"}
        format.json { render json: @contact }
      else
        format.html { render action: 'new' }
        format.js {render layout: false, template: "contacts/new"}
        format.json { render json: false }
      end
    end
  end

  def update
    @contact = Contact.find_by(id: params[:id])
    if @contact.nil?
      flash[:error] = "Specified contact not found."
      return redirect_to contacts_path
    end
    params[:contact_type] = "company" if !@contact.company_name.nil?
    @contact.legal_ending = nil if @contact.company_name.nil?
    @contact.cprefix =  (params[:contact_type] == "company") ? "Contact " : ""
    @contact.assign_attributes(contact_params)
    @contact.role = "Counter-Party"
    if @contact.contact_type == "Client Participant"
      @contact.role = @contact.cp_role
    elsif @contact.contact_type == "Personnel"
      @contact.role = @contact.per_role
    end

    respond_to do |format|
      if @contact.save
        if params[:from_relinquishing_offeror].present?
          if @contact.is_company
            TransactionPropertyOffer.find(params[:from_relinquishing_offeror]).update(offer_name: "#{@contact.company_name}")
          else
            TransactionPropertyOffer.find(params[:from_relinquishing_offeror]).update(offer_name: "#{@contact.first_name} #{@contact.last_name}")
          end
        end
        format.html { redirect_to contacts_path }
        format.js {render layout: false, template: "contacts/new"}
        format.json { render json: @contact }
      else
        format.html { render action: 'edit' }
        format.js {render layout: false, template: "contacts/new"}
        format.json { render json: false }
      end
    end
  end

  def index
    @contacts = Contact.with_deleted
    @contacts = @contacts.where(deleted_at: nil) unless params[:trashed].to_b
    @contacts = @contacts.where.not(deleted_at: nil) if params[:trashed].to_b
    @contacts = @contacts.where(user_id: current_user.id)
    @contacts = @contacts.order(created_at: :desc).paginate(page: params[:page], per_page: sessioned_per_page)
    @activeId = params[:active_id]
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/contacts\">Contacts </a></h4></div>".html_safe
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/contacts/new\"> List </a></h4></div>".html_safe
  end

  def show
    @contact = Contact.find_by(id: params[:id])

    if @contact.nil?
      flash[:error] = "Specified contact not found."
      return redirect_to contacts_path
    else
      @ctype_ = "Individual"
      @ctype_ = "Company" if @contact.is_company
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/contacts\">Contacts </a></h4></div>".html_safe
      add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"#{contact_path(@contact.id)}\">Show #{@ctype_} Contact: #{@contact.name} </a></h4></div>".html_safe
    end
  end

  def edit
    @contact = Contact.find_by(id: params[:id])
    params[:contact_type] = "company" if !@contact.company_name.nil?
    @contact.cprefix =  (params[:contact_type] == "company") ? "Contact " : ""
    if @contact.nil?
      flash[:error] = "Specified contact not found."
      return redirect_to contacts_path
    end
    if @contact.contact_type == "Client Participant"
      @contact.cp_role = @contact.role
    elsif @contact.contact_type == "Personnel"
      @contact.per_role = @contact.role
    end
    ctype_ = "Individual"
    ctype_ = "Company" if @contact.is_company
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/contacts\">Contacts </a></h4></div>".html_safe
    add_breadcrumb "<div class=\"pull-left\"><h4><a href=\"/contacts/new\">Edit #{ctype_} Contact: #{@contact.name} </a></h4></div>".html_safe

  end

  def destroy
    @contact = Contact.find_by(id: params[:id])
    @contact.try(:destroy)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def multi_delete
    common_multi_delete
  end

  private

  def current_page
    @current_page = 'contacts'
  end


  def contact_params
    params.require(:contact).permit!
  end

end
