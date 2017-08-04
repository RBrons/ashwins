class TransactionPropertyOffer < ApplicationRecord
  belongs_to :transaction_property, touch: true
  has_many :counteroffers, foreign_key: :transaction_property_offer_id, dependent: :destroy

  belongs_to :contact, primary_key: :relinquishing_purchaser_contact_id, dependent: :destroy

  delegate :name, to: :contact, allow_nil: true

  def is_ask_accepted?
    if self.accepted_counteroffer_id != 0
      return false
    else
      return true
    end
  end
  
end
