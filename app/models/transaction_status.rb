class TransactionStatus < ApplicationRecord
  self.table_name = 'transaction_status'

  enum type_is: { Sale: 1, Purchase: 0 }

  belongs_to :transaction_sale, primary_key: :transaction_id

  scope :find_purchase, -> { find_by(type_is: 0) }
  scope :find_sale, -> { find_by(type_is: 1) }

end
