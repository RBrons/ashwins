class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :move_remove_entry_from_unregistered, :create_default_tenants

  has_many :tenants

  private
  def move_remove_entry_from_unregistered
    unregistered = Users::Unregistered.find_by(email: self.email)
    if unregistered.present?
      AccessResource.where(can_access: false, unregistered_u_k: unregistered.key).update_all(can_access: true, user_id: self.id, unregistered_u_k: nil)
      unregistered.delete
    end
  end

  private

  public

  def create_default_tenants
    Property::TENANTS.each do |tenant|
      self.tenants.create(name: tenant)
    end
  end

  def update_last_active
    self.update_column(:last_active, DateTime.now)
  end

  def super_admin?
    email.in? %w(theapptimist@gmail.com danhalper@gmail.com)
  end

  def welcome_user
    AdminMailer.welcome_user(self).deliver
    AdminMailer.notification_to_admin(self).deliver
  end

  def ability
    true
  end


  # Views
  def name
    "#{first_name} #{last_name}"
  end

  def created_at_to_string
    created_at.to_string
  end

  def delete_url
    Rails.application.routes.url_helpers.admin_user_path(self)
  end

  def self.resources_url
    Rails.application.routes.url_helpers.admin_users_path
  end

  def unset_link
    ActionController::Base.helpers.link_to('Make Admin',
                                           Rails.application.routes.url_helpers.set_unset_admin_user_path(self),
                                           class: 'btn btn-sm btn-warning', method: :post)
  end

  def enable_disable_link
    ActionController::Base.helpers.link_to((self.enabled ? 'Disable' : 'Enable'),
                                           Rails.application.routes.url_helpers.enable_disable_admin_user_path(self),
                                           class: "btn btn-sm #{(self.enabled ? 'btn-warning' : 'btn-success')}", method: :post)
  end

  def self.view_index_columns
    [
      { show: 'Name', call: 'name' },
      { show: 'Email', call: 'email' },
      { show: 'Sign up', call: 'created_at_to_string' },
      { show: 'Make Admin', call: 'unset_link' },
      { show: 'Enable / Disable', call: 'enable_disable_link' },
    ]
  end

  def entities_list(nid=0)
    Entity.where(id: AccessResource.get_ids({user: self, resource_klass: 'Entity'})-[nid] ).where.not(name: [nil, ''])
  end

  def EntitesForClient(nid=0)
    Entity.where(id: AccessResource.get_ids({user: self, resource_klass: 'Entity'})-[nid]).
      where.not(name: [nil, '']).order(name: :asc).pluck(:name, :id, :type_).map! {
        |x| ["#{x[0]} (#{MemberType.member_types[x[2]]})", x[1]]
      }
  end

end
