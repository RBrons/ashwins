class Settlor < PeopleAndFirm

  include MyFunction
  include ModelMethods

  default_scope{ where(class_name: "Settlor")}
  validate :entity_presence
  # validates_presence_of :first_name, :last_name
  validates_length_of :first_name, :last_name, :email, :phone_number, maximum: 250
  belongs_to :super_entity, class_name: "SuperEntity"
  belongs_to :entity
  belongs_to :contact
  after_save :add_key

  def entity_presence
    if self.entity.blank? && self.contact.blank? && self.first_name.blank? && self.last_name.blank? && self.temp_id.blank?
      errors.add(:entity, "is invalid, Please add it before saving")
      return
    end
  end

  def type_
    MemberType.find(Entity.find(self.entity_id).type_).name rescue ""
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