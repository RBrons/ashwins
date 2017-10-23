class QualifiedIntermediary < ApplicationRecord
  has_many :qualified_intermediary_deposits
  accepts_nested_attributes_for :qualified_intermediary_deposits, :reject_if => :all_blank
  has_one :wired_instruction
  accepts_nested_attributes_for :wired_instruction

  has_one :contact, foreign_key: :type_id, primary_key: :uuid
  accepts_nested_attributes_for :contact

  def wired_instruction
    super || create_wired_instruction
  end

  def contact
    super || create_contact
  end

  before_save do
    self.uuid = Key.unused_key if self.uuid.blank?
  end
end
