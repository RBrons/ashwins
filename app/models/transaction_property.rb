class TransactionProperty < ApplicationRecord

  belongs_to :transaction_sale, touch: true
  belongs_to :transaction_purchase, touch: true
  
  belongs_to :property
  delegate :name, to: :property, allow_nil: true
  delegate :owner, to: :property, allow_nil: true

  has_one :transaction_term, foreign_key: :transaction_property_id, dependent: :destroy
  accepts_nested_attributes_for :transaction_term, :reject_if => :all_blank

  has_many :transaction_property_offers, foreign_key: :transaction_property_id, dependent: :destroy

  delegate :transaction_term_closing_date, to: :transaction_term, allow_nil: true
  delegate :first_deposit_date_due, to: :transaction_term, allow_nil: true
  delegate :inspection_period_days, to: :transaction_term, allow_nil: true
  delegate :psa_date, to: :transaction_term, allow_nil: true
  delegate :second_deposit_date_due, to: :transaction_term, allow_nil: true

  delegate :measured_days_to_1st_deposit, to: :transaction_term, allow_nil: true
  delegate :measured_days_to_end_of_inspection, to: :transaction_term, allow_nil: true
  delegate :measured_days_to_2nd_deposit, to: :transaction_term, allow_nil: true
  delegate :measured_days_to_closing, to: :transaction_term, allow_nil: true
  delegate :last_day_for_buyer_to_receive_deposit, to: :transaction_term, allow_nil: true
  
  after_touch :update_transaction
  after_update :update_transaction
  after_save :update_transaction
  
  def update_transaction
    if self.is_sale
      TransactionSale.find(self.transaction_id).touch
    else
      TransactionPurchase.find(self.transaction_id).touch
    end
  end

  def is_in_contract?
    return !self.psa_date.nil?
  end
  
  def closed?
    return !self.closing_date.nil?
  end

  def asking_accepted?
    accepted_offer = self.transaction_property_offers.where(:is_accepted => true).first
    if accepted_offer.present?
      return accepted_offer.is_ask_accepted?
    else
      return false
    end
  end
end
