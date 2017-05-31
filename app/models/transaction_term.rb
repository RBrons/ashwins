class TransactionTerm < ApplicationRecord

  def sale
    TransactionSale.find_by(id: self.transaction_id)
  end

  def purchase
    TransactionPurchase.find_by(id: self.transaction_id)
  end

  def measured_days_to_1st_deposit
    if self.psa_date.present? && self.first_deposit_days_after_psa.present?
      offset = (Date.today - self.psa_date )
      return self.first_deposit_days_after_psa - offset.to_i
    else
      return 0
    end
  end

  def measured_days_to_end_of_inspection
    if self.psa_date.present? && self.inspection_period_days.present?
      offset = (Date.today - self.psa_date )
      return self.inspection_period_days - offset.to_i
    else
      return 0
    end
  end

  def measured_days_to_2nd_deposit
    if self.psa_date.present? && self.second_deposit_days_after_inspection_period.present?
      offset = (Date.today - self.psa_date )
      return self.second_deposit_days_after_inspection_period - offset.to_i
    else
      return 0
    end
  end

  def measured_days_to_closing
    if self.psa_date.present? && self.closing_days_after_inspection_period.present?
      offset = (Date.today - self.psa_date )
      return self.closing_days_after_inspection_period - offset.to_i
    else
      return 0
    end
  end

  def last_day_for_buyer_to_receive_deposit
    if self.psa_date.present? && self.inspection_period_days.present?
      return self.psa_date + self.inspection_period_days.day
    else
      return ''
    end
  end

  def transaction_term_closing_date
    self.closing_date
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

  before_create :set_contract_deadline_date
  before_save :set_contract_deadline_date

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
  def set_contract_deadline_date
    self.inspection_period_days = 30 if self.inspection_period_days.blank?

    if !self.first_deposit_date_due.present?
      if self.psa_date.present?
        self.first_deposit_date_due = (self.psa_date + eval("#{self.first_deposit_days_after_psa}.days")).to_date
      else
        self.first_deposit_date_due = (Time.zone.now + eval("#{self.first_deposit_days_after_psa.to_i}.days")).to_date
      end
    else
      self.first_deposit_days_after_psa = self.first_deposit_date_due - self.psa_date if self.psa_date
    end

    if self.second_deposit
      if !self.second_deposit_date_due.present?
        if self.psa_date.present? && self.second_deposit_days_after_inspection_period.present?
          self.second_deposit_date_due = (self.psa_date + eval("#{self.second_deposit_days_after_inspection_period}.days") + 3.days).to_date
        else
          self.second_deposit_date_due = (Time.zone.now + eval("#{self.second_deposit_days_after_inspection_period}.days") + 3.days).to_date
        end
      else
        self.second_deposit_days_after_inspection_period = self.second_deposit_date_due - self.psa_date
      end
    end

    if !self.closing_date.present?
      if self.psa_date.present?
        self.closing_date = (self.psa_date + eval("#{self.closing_days_after_inspection_period}.days")).to_date
      else
        self.closing_date = (Time.zone.now + eval("#{self.closing_days_after_inspection_period.to_i}.days")).to_date
      end
    else
      self.closing_days_after_inspection_period = self.closing_date - self.psa_date if self.psa_date
    end

  end

end
