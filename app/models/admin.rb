class Admin < ApplicationRecord
  
  self.table_name = 'users'
  
  default_scope -> { where(admin: true) }
  
  # Views
  def name
    "#{first_name} #{last_name}"
  end
  
  def created_at_to_string
    created_at.to_string
  end
  
  def delete_url
    Rails.application.routes.url_helpers.admin_admin_path(self)
  end
  
  def self.resources_url
    Rails.application.routes.url_helpers.admin_admins_path
  end
  
  def unset_link
    ActionController::Base.helpers.link_to('Remove Admin',
                                           Rails.application.routes.url_helpers.set_unset_admin_admin_path(self),
                                           class: 'btn btn-sm btn-warning', method: :post)
  end
  
  def self.view_index_columns
    [
      { show: 'Name', call: 'name' },
      { show: 'Email', call: 'email' },
      { show: 'Remove As Admin', call: 'unset_link' },
    ]
  end

end
