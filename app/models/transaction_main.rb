class TransactionMain < ApplicationRecord
  
  has_one :sale, class_name: 'TransactionSale', dependent: :destroy
  has_one :purchase, class_name: 'TransactionPurchase', dependent: :destroy

  has_many :transaction_properties, dependent: :destroy
  
  attr_accessor :sale_status, :purchase_status
  
  before_save do
    if self.sale.present?
      self.sale.update_column(:status, self.sale_status)
    end
    
    if self.purchase.present?
      self.purchase.update_column(:status, self.purchase_status)
    end
  end
  
  def has_purchase?
    self.purchase.present?
  end
  
  def has_sale?
    self.sale.present?
  end

end
