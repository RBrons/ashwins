class HomeController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:index]

  def index
    if !current_user
      redirect_to new_user_session_path
    end
    
    landing_page_action = DefaultValue.where(entity_name: 'ShowLandingPage').first
    if landing_page_action.present?
      @show_landing_page = landing_page_action.value
    else
      @show_landing_page = false
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
