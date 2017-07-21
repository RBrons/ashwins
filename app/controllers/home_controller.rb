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

    @greeting = DefaultValue.where(entity_name: 'Greeting').first.present? ? DefaultValue.where(entity_name: 'Greeting').first.value : ''

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
