class MembersController < ApplicationController

  def new
    @member = Member.new(member_type_id: params[:type].to_i, resource_id: params[:resource_id])
    render layout: false
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      render text: 'ok'
    else
      render layout: false, template: "members/new"
    end
  end

  def edit
    @member = Member.find(params[:id])
    render layout: false
  end

  def delete
    @member = Member.find(params[:id])
    @member.delete
    redirect_to :back
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      render text: 'ok'
    else
      render layout: false, template: "members/edit"
    end
  end

  def member_params
    params.require(:member).permit(:resource_id, :first_name_or_entity_name, :last_name, :email,
                                   :phone_number, :snail_mail_address, :number_of_share, :membership_percentage,
                                   :tax_member, :managing_member, :undivided_interest, :partnership_interest,
                                   :general_partner)
  end
end
