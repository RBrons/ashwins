class StockHolder < PeopleAndFirm

  include MyFunction
  include ModelMethods

  default_scope{ where(class_name: "StockHolder")}
  validate :entity_presence
  # validate :reset_first_name_or_entity_id
  # validates_presence_of :first_name, :last_name
  validates_length_of :first_name, :last_name, :email, :postal_address, :fax, :phone1, :phone2, :city, :state, :zip, maximum: 250
  # validates :email, email: true, if: "self.email.present?"
  validates_length_of :ein_or_ssn, is: 9, if: "self.ein_or_ssn.present?"
  validates_format_of :ein_or_ssn, :with => /\A([A-Za-z0-9]+)\Z/i, message: " is invalid", if: "self.ein_or_ssn.present?"
  validate :validate_my_percentage

  belongs_to :super_entity, class_name: "SuperEntity"
  belongs_to :entity
  belongs_to :contact
  after_save :add_key

  attr_accessor :share_error

  def entity_presence
    if self.entity.blank? && self.contact.blank? && self.first_name.blank? && self.last_name.blank? && self.temp_id.blank?
      errors.add(:entity, "is invalid, Please add it before saving")
      return
    end
  end

  def type_
    MemberType.find(Entity.find(self.entity_id).type_).name rescue ""
  end

  def total_stock_share
    self.super_entity.total rescue nil
  end

  def remaining_stock_share
    val   = StockHolder.where(super_entity_id: self.super_entity_id).sum(:my_percentage_stockholder)
    val ||= 0
    ((total_stock_share || 0) - val) rescue ""
  end

  def percentage_of_ownership
    if self.total_stock_share
      ((self.my_percentage_stockholder.try(:to_f)/self.total_stock_share)*100).to_i rescue ""
    else
      ""
    end
  end

  def reset_first_name_or_entity_id
    if self.is_person?
      self.entity_id = nil
    end
  end

  def validate_my_percentage

    if self.remaining_share_or_interest_ <= 0
      errors.add(:share_error, "now remaining is Zero")
      return
    end

    if self.my_percentage_stockholder.blank?
      errors.add(:stock_share, "can not be blank")
      return
    end

    if self.my_percentage_stockholder.to_f <= 0
      errors.add(:stock_share, "must be more than zero")
      return
    end

    if self.my_percentage_stockholder.to_f > self.remaining_share_or_interest_
      errors.add(:stock_share, "must be less than or equal to #{self.remaining_share_or_interest_}")
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
