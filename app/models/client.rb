class Client < ApplicationRecord
  
  acts_as_paranoid
  
  include MyFunction
  
  validate :entity_presence
  validates_presence_of :first_name, :last_name
  validates_length_of :first_name, :last_name, :email, :postal_address, :fax, :phone1, :phone2, :city, :state, :zip, :ein_or_ssn, maximum: 250
  has_many :transaction_sales
  has_many :transaction_purchases
  after_save :add_key
  before_save :set_info
  belongs_to :entity
  
  def self.purchased_entity
    where("client_type != ? OR client_type is NULL", "individual")
  end
  
  def self.purchased_person
    where(client_type: "individual")
  end
  
  
  private
  def set_info
    self.info = ''
    self.info += "#{self.first_name} \n" if self.first_name.present?
    self.info += "#{self.last_name} \n" if self.last_name.present?
    self.info += "#{self.entity.name} \n" if self.entity.try(:name).present?
    self.info += "#{self.email} \n" if self.email.present?
    self.info += "#{self.postal_address} \n" if self.postal_address.present?
    self.info += "#{self.city} \n" if self.city.present?
    self.info += "#{self.state} \n" if self.state.present?
    self.info += "#{self.zip} \n" if self.zip.present?
    self.info += "#{self.fax} \n" if self.fax.present?
    self.info += "#{self.phone1} \n" if self.phone1.present?
    self.info += "#{self.phone2} \n" if self.phone2.present?
    self.info += "#{self.notes} \n" if self.notes.present?
  end
  
  def entity_presence
    unless self.is_person?
      if self.entity.blank?
        errors.add(:entity, "is invalid, Please add it before saving")
        return
      end
    end
  end
  
  public
  def type_
    MemberType.find(self.entity.type_).name rescue ""
  end

  # Views
  def name
    "#{self.first_name} #{self.last_name}"
  end
  
  def city_state
    "#{self.city} #{self.state}"
  end
  
  def created_at_to_string
    created_at.to_string
  end

  def delete_url
    Rails.application.routes.url_helpers.admin_client_path(self)
  end
  
  def self.resources_url
    Rails.application.routes.url_helpers.admin_clients_path
  end

  def self.view_index_columns
    [
      { show: 'Name', call: 'name' },
      { show: 'Email', call: 'email' },
      { show: 'Address', call: 'postal_address' },
      { show: 'City, State', call: 'city_state' },
      { show: 'Created', call: 'created_at_to_string' },
    ]
  end

end