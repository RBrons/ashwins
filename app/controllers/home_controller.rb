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

    initial_sign_in_modal_action = DefaultValue.where(entity_name: 'ShowInitialSignInModal').first
    if initial_sign_in_modal_action.present?
      @show_initial_sign_in_modal = initial_sign_in_modal_action.value
    else
      @show_initial_sign_in_modal = false
    end
    @show_initial_sign_in_modal &&= !current_user.contact_info_entered?

    @exchangor = Entity.where(id: AccessResource.get_ids({user: current_user, resource_klass: 'Entity'})).first
    @relinquishing_purchaser = Contact.where(contact_type: 'Counter-Party', user_id: current_user.id).first
    @replacement_property =  Property.where('ownership_status = ? and title is not null and user_id = ?', 'Prospective Purchase', current_user.id).first
    
    if @exchangor.present?
      @has_purchased_properties = @exchangor.has_purchased_properties?
      
      if @has_purchased_properties && @relinquishing_purchaser.present? && @replacement_property.present?
        @completed_initial_sequence = true
      else
        @completed_initial_sequence = false
      end
    else
      @completed_initial_sequence = false
    end
    
    @greeting = DefaultValue.where(entity_name: 'Greeting').first.present? ? DefaultValue.where(entity_name: 'Greeting').first.value : ''
    @firms = AttorneyFirm.all()

    @back_path = URI(request.referer || '').path
    if @back_path == '/users/sign_in'
      @back_url = current_user.last_sign_out_page || '#'
    elsif @back_path == '/' || @back_path.include?('admin/')
      @back_url = '#'
    else
      @back_url = request.referer
    end
  end

  def set_user_indexing
    current_user.update(user_indexing: params[:set_val] == 'true')
    render :json => { :success => true}
  end

  def test
    render layout: false
  end
end
