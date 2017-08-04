class EntityGuardianship < ApplicationRecord
  self.table_name = "entities"

  include MyFunction

  class_attribute :basic_info_only
  validates_presence_of :first_name, :last_name
  validates :email, email: true, if: "self.email.present?"
  # validate :phone_validation
 # validates_presence_of :name2
  validates_length_of :name, maximum: 250
  validates_length_of :name2, maximum: 250
  validates_length_of :first_name, :last_name, :county, maximum: 250
  validates_length_of :city2, maximum: 250, if: "self.city2.present?"
  validates_length_of :state2, maximum: 250, if: "self.state2.present?"
  validates_length_of :zip2, maximum: 250, if: "self.zip2.present?"
  validates_length_of :country, maximum: 250, if: "self.country.present?"
  validates_length_of :postal_address2, maximum: 250, if: "self.postal_address2.present?"
  validates_length_of :country2, maximum: 250, if: "self.country2.present?"
  validates_length_of :index, maximum: 250, if: "self.index.present?"
  validates_numericality_of :part, maximum: 2, if: "self.part.present?"
  validate :check_uniqueness
  validate :valid_date_of_formation

  belongs_to :entity_type, class_name: "EntityType", foreign_key: "type_"
  has_many :members, class_name: "Member", foreign_key: "super_entity_id"
  has_many :officers
  has_many :stockholders, ->{where(class_name: "StockHolder")}, class_name: "StockHolder", foreign_key: "super_entity_id"
  has_one :judge, ->{where(class_name: "Judge")}, class_name: "Judge", foreign_key: "super_entity_id"
  has_one :guardian, ->{where(class_name: "Guardian")}, class_name: "Guardian", foreign_key: "super_entity_id"
  has_one :ward, ->{where(class_name: "Ward")}, class_name: "Ward", foreign_key: "super_entity_id"
  has_many :directors, ->{where(class_name: "Director")}, class_name: "Director", foreign_key: "super_entity_id"
  has_many :managers, ->{where(class_name: "Manager")}, class_name: "Manager", foreign_key: "super_entity_id"
  has_many :partners, ->{where(class_name: "Partner")}, class_name: "Partner", foreign_key: "super_entity_id"
  has_many :limited_partners, ->{where(class_name: "LimitedPartner")}, class_name: "LimitedPartner", foreign_key: "super_entity_id"
  has_many :general_partners, ->{where(class_name: "GeneralPartner")}, class_name: "GeneralPartner", foreign_key: "super_entity_id"
  has_many :settlors, ->{where(class_name: "Settlor")}, class_name: "Settlor", foreign_key: "super_entity_id"
  has_many :trustees, ->{where(class_name: "Trustee")}, class_name: "Trustee", foreign_key: "super_entity_id"
  has_many :beneficiaries, ->{where(class_name: "Beneficiary")}, class_name: "Beneficiary", foreign_key: "super_entity_id"

  after_save :add_key

end
