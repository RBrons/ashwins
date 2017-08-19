class AttorneyFirm < ApplicationRecord
  has_one :user

  def contact_name
    return "#{self.first_name} #{self.last_name}"
  end
end
