class TransactionPersonnel < ApplicationRecord

  belongs_to :contact
  belongs_to :transaction_sale

  FIXED_TITLE = ['Title', 'Survey', 'Environmental', 'Zoning']

end
