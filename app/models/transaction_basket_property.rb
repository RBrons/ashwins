class TransactionBasketProperty < ApplicationRecord
  belongs_to :transaction_basket, touch: true
  
  belongs_to :property
end
