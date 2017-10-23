class Admin::ContactsController < Admin::AdminController
  
  def resource_class_with_condition
    Contact
  end

  def personnel
    @show_other_personnel = DefaultValue.where(entity_name: 'ShowPersonnel').first.try(:value)

    @personnel = Contact.where(user_id: current_user.id, contact_type: 'Personnel', deleted_at: nil)
    @personnel = @personnel.order(created_at: :desc).paginate(page: params[:page], per_page: sessioned_per_page)
  end
  
end