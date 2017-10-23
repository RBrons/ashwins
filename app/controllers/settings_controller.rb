class SettingsController < ApplicationController
  
  def per_page
     sessioned_per_page(params[:per_page])
     redirect_to :back
  end
end
