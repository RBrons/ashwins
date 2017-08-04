class Director < PeopleAndFirm

  belongs_to :entity

  include MyFunction

  default_scope{ where(class_name: "Director")}
  # validate :phone_validation
  # validates_presence_of :first_name, :last_name
  validates :email, email: true, if: "self.email.present?"
  validates_length_of :first_name, :last_name, :email, :postal_address, :fax, :phone1, :phone2, :city, :state, :zip, maximum: 250
  after_save :add_key
  belongs_to :super_entity, class_name: "SuperEntity"

  validate :entity_presence

  belongs_to :contact

  def entity_presence
    if self.entity.blank? && self.contact.blank? && self.first_name.blank? && self.last_name.blank? && self.temp_id.blank?
      errors.add(:entity, "is invalid, Please add it before saving")
      return
    end
  end

  def name
    if self.entity.present?
      self.entity.name
    elsif self.contact.present?
      self.contact.name
    else
      "#{self.first_name} #{self.last_name}"
    end
  end

end
