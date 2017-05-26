class TransactionPropertyOffer < ApplicationRecord
  belongs_to :transaction_property, primary_key: :transaction_property_id
  has_many :counteroffers, foreign_key: :transaction_property_offer_id, dependent: :destroy

  def is_ask_accepted?
    if self.accepted_counteroffer_id != 0
      return false
    else
      return true
    end
  end
  
end
