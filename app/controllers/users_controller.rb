class UsersController < ApplicationController

  before_filter :authenticate_user!

  def update
    attributes = build_update_attributes
    @user = User.find(params[:id])
    if params[:status]
      @user.update_attributes(default: params[:status])
    elsif attributes
      @user.update_attributes(attributes)
    elsif params[:just_email]
      @user.update_attributes(just_email: params[:just_email])
    elsif params[:have_alt]
      @user.update_attributes(have_alt: params[:have_alt])
    end
    render :json => {:success => true}
  end

  def set_contact_info
    @user = current_user
    visitor = ''
    if request.post?
      if params[:contact_type] == 'business'
        if params[:firm_id].present?
          if params[:firm_id].to_i != 0
            @user.attorney_firm_id = params[:firm_id].to_i
          else
            # Save new Attorney Firm.
            if params[:firm_name].present?
              if AttorneyFirm.exists?(:name => params[:firm_name])
                firm = AttorneyFirm.where(:name => params[:firm_name]).first
                firm.update(:name => params[:firm_name])
              else
                firm = AttorneyFirm.create(:name => params[:firm_name])
              end
              @user.attorney_firm_id = firm.id
            else
              # Big issue
              return render json: {status: false}
            end
          end
          @user.first_name = params[:first_name]
          @user.last_name = params[:last_name]
          @user.business_name = nil

          @user.user_type = params[:user_type]
                    
          @user.save
          visitor = @user.first_name + ' from ' + @user.attorney_firm.name
        else
          @user.business_name = params[:business_name]
          @user.first_name = params[:first_name]
          @user.last_name = params[:last_name]
          @user.attorney_firm_id = nil
          @user.user_type = params[:user_type]

          @user.save
          visitor = @user.first_name + ' from ' + @user.business_name
        end
      elsif params[:contact_type] == 'individual'
        @user.first_name = params[:first_name]
        @user.last_name = params[:last_name]
        @user.business_name = nil
        @user.attorney_firm_id = nil

        @user.user_type = params[:user_type]

        @user.save
        visitor = @user.first_name
      else
        return render json: {status: false}
      end  
      
      return render json: {status: true, visitor: visitor, user_type: @user.user_type}
    else
      return render json: {status: false}  
    end

  end

  def my
    @user = current_user
    if request.post?
      @user.first_name = params[:first_name]
      @user.last_name = params[:last_name]
      @user.save
      sign_in @user.reload
    end
  end

  private

  def build_update_attributes
    attributes = nil
    if params[:just_email] || params[:have_alt]
      if params[:just_email] == 'true'
        attributes = {just_email: 'true', have_alt: 'false'}
      end
      if params[:have_alt] == 'true'
        attributes = {just_email: 'false', have_alt: 'true'}
      end
    end
    attributes
  end
end
