class Admin::PropertiesController < Admin::AdminController

  def resource_class_with_condition
    Property
  end

  def sold_to_purchased
    Property.where(ownership_status: 'Sold').each do |p|
      p.update_attribute(:ownership_status, 'Purchased')
    end

    # flash[:success] = "All Sold Properties have been changed to Purchased."
    return redirect_to admin_properties_path
  end

end