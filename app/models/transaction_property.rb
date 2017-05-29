class TransactionProperty < ApplicationRecord

  belongs_to :transaction_sale, primary_key: :transaction_id
  belongs_to :transaction_purchase, primary_key: :transaction_id
  belongs_to :property

  has_one :transaction_term, foreign_key: :transaction_property_id, dependent: :destroy
  accepts_nested_attributes_for :transaction_term, :reject_if => :all_blank

  has_many :transaction_property_offers, foreign_key: :transaction_property_id, dependent: :destroy

  delegate :name, to: :property, allow_nil: true

  def closed?
    return !self.closing_date.nil?
  end
end
