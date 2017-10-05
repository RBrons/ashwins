class AttorneyFirm < ApplicationRecord
  has_one :user

  scope :firms, -> { where(:type_ => 'Firm') }
  scope :offices, -> { where(:type_ => 'Office') }
end
