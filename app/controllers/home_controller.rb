class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:index]

  def index
    if !current_user
      redirect_to new_user_session_path
      return
    end
    
    landing_page_action = DefaultValue.where(entity_name: 'ShowLandingPage').first
    if landing_page_action.present?
      @show_landing_page = landing_page_action.value
    else
      @show_landing_page = false
    end
    
    if params[:shown_modal] != 'user-setup'
      initial_sign_in_modal_action = DefaultValue.where(entity_name: 'ShowInitialSignInModal').first
      if initial_sign_in_modal_action.present?
        @show_initial_sign_in_modal = initial_sign_in_modal_action.value
      else
        @show_initial_sign_in_modal = false
      end
      @show_initial_sign_in_modal &&= !current_user.contact_info_entered? && !current_user.skipped_user_setup
    else
      @show_initial_sign_in_modal = true
    end

    @transactions_in_user = []
    if !@show_initial_sign_in_modal
      # Make Transaction Participants Tab
      sale_transactions = TransactionSale.joins(:transaction_main).where('transaction_mains.user_id' => current_user.id, 'transactions.deleted_at' => 
      nil).select('DISTINCT on (transactions.relinquishing_seller_entity_id) transactions.*')

      purchase_transactions = TransactionPurchase.joins(:transaction_main).where('transaction_mains.user_id' => current_user.id, 'transactions.deleted_at' => nil)
      del_transaction_ids = []
      purchase_transactions.each do |purchase_transaction|
        main = purchase_transaction.main
        sale = main.sale
        if !sale.nil?
          if purchase_transaction.created_at > sale.created_at
            tprops = sale.transaction_properties
            del_flag = true
            tprops.each do |prop|

              if prop.closed?
                del_flag = false
                break
              end
            end
            del_transaction_ids << purchase_transaction.id if del_flag
          end
        end
      end
      purchase_transactions = purchase_transactions.where.not('transactions.id in (?)', del_transaction_ids) if del_transaction_ids.count > 0
      purchase_transactions = purchase_transactions.joins(:transaction_properties).joins('INNER JOIN properties ON properties.id = transaction_properties.property_id AND properties.deleted_at IS NULL').select('DISTINCT on (properties.id) transactions.*, properties.id as p_id, properties.title as p_title')
      
      @transactions_in_user = (sale_transactions + purchase_transactions).sort_by(&:updated_at).reverse
    end

    @greeting = DefaultValue.where(entity_name: 'Greeting').first.present? ? DefaultValue.where(entity_name: 'Greeting').first.value : ''
    
    back_path = URI(request.referer || '').path
    if back_path == '/users/sign_in'
      @back_url = current_user.last_sign_out_page || '#'
    elsif back_path == '/' || back_path.include?('admin/') || back_path.empty?
      @back_url = '#'
    else
      @back_url = request.referer
    end
  end

  def set_user_indexing
    current_user.update(user_indexing: params[:set_val] == 'true')
    render :json => { :success => true}
  end

  def initial_participants
    @exchangor = Entity.where(id: AccessResource.get_ids({user: current_user, resource_klass: 'Entity'})).first
    @relinquishing_purchaser = Contact.where(contact_type: 'Counter-Party', user_id: current_user.id).first
    @replacement_property =  Property.where('ownership_status = ? and title is not null and user_id = ?', 'Prospective Purchase', current_user.id).first
    
    if @exchangor.present?
      @has_purchased_properties = @exchangor.has_purchased_properties?
      if @has_purchased_properties
        @purchased_property_id = Property.where(ownership_status: 'Purchased', owner_entity_id: @exchangor.id).first.id
      end
    end
  end

  def test
    render layout: false
  end
end
