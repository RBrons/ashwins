class TransactionPropertyOffer < ApplicationRecord
  belongs_to :transaction_property, touch: true
  has_many :counteroffers, foreign_key: :transaction_property_offer_id, dependent: :destroy

  belongs_to :offeror, class_name: 'Contact', foreign_key: :client_contact_id, dependent: :destroy
  belongs_to :broker, class_name: 'Contact', foreign_key: :broker_contact_id, dependent: :destroy
  belongs_to :attorney, class_name: 'Contact', foreign_key: :attorney_contact_id, dependent: :destroy

  delegate :name, to: :contact, allow_nil: true

  # Accepted the price that client is asking without counteroffer
  def accepted_asking?
    if self.accepted_counteroffer_id != 0
      return false
    else
      return true
    end
  end
  
end
