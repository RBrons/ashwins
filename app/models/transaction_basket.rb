class TransactionBasket < ApplicationRecord

  belongs_to :transaction_purchase, touch: true

  has_many :transaction_basket_properties, foreign_key: :transaction_basket_id, dependent: :destroy
  
  after_touch :update_transaction
  after_update :update_transaction
  after_save :update_transaction
  
  def update_transaction
    TransactionPurchase.find(self.transaction_id).touch
  end

end
