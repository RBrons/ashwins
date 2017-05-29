class TransactionTerm < ApplicationRecord

  def sale
    TransactionSale.find_by(id: self.transaction_id)
  end
  
  def purchase
    TransactionPurchase.find_by(id: self.transaction_id)
  end
  
  validate :closing_date_with_psa_date
  
  after_save do
    if self.closing_date.present? && self.closing_date != self.closing_date_was
      if self.purchase.present?
        self.purchase.update_column(:status, 'Closing Date Set')
      elsif self.sale.present?
        self.sale.update_column(:status, 'Closing Date Set')
      end
    end
  end
  
  before_create :set_second_deposit_date
  before_save :set_second_deposit_date

  private
  def closing_date_with_psa_date
    if self.closing_date.present? && self.psa_date.present?
      if self.psa_date > self.closing_date
        errors.add(:base, 'Date of Purchase Sale Agreement can not greater than Closing Date')
        return false
      end
    end
  end

  private
  def set_second_deposit_date
    self.inspection_period_days = 30 if self.inspection_period_days.blank?
    if self.psa_date.present? && self.inspection_period_days.present?
      self.second_deposit_date_due = (self.psa_date + eval("#{self.inspection_period_days}.days") + 3.days).to_date
    end
  end

end
