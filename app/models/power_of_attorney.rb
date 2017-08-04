class PowerOfAttorney < ApplicationRecord

  self.table_name = "entities"

  include MyFunction

  class_attribute :basic_info_only
  # validates :email, email: true, if: "self.email.present?"

  # validates_presence_of :first_name, :last_name, :date_of_formation
  validates_length_of :name, maximum: 250
  validates_length_of :name2, maximum: 250
  validates_length_of :first_name, :last_name, maximum: 250
  validates_length_of :city2, maximum: 250, if: "self.city2.present?"
  validates_length_of :state2, maximum: 250, if: "self.state2.present?"
  validates_length_of :zip2, maximum: 250, if: "self.zip2.present?"
  validates_length_of :country, maximum: 250, if: "self.country.present?"
  validates_length_of :postal_address2, maximum: 250, if: "self.postal_address2.present?"
  validates_length_of :country2, maximum: 250, if: "self.country2.present?"
  validates_length_of :index, maximum: 250, if: "self.index.present?"
  validates_numericality_of :part, maximum: 2, if: "self.part.present?"
  # validate :validate_agent
  # validate :check_uniqueness
  validate :valid_date_of_formation

  belongs_to :entity_type, class_name: "EntityType", foreign_key: "type_"
  has_one :principal, class_name: "Principal", foreign_key: "super_entity_id"

  after_save :add_key
  before_save :set_default_val

  def set_default_val
    self.number_of_assets = 100
  end

  private

  def validate_agent
    if first_name2.blank?
      errors.add(:agent_first_name, " can't be blank")
    end
    if last_name2.blank?
      errors.add(:agent_last_name, " can't be blank")
    end
  end
end
