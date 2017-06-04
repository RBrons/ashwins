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

  before_create :set_defaul_contract_deadline_date
  before_save :set_defaul_contract_deadline_date

  before_update :set_first_deposit_days_after_psa, if: :first_deposit_date_due_changed?
  before_update :set_second_deposit_days_after_inspection_period, if: :second_deposit_date_due_changed?
  before_update :set_closing_days_after_inspection_period, if: :closing_date_changed?

  before_update :set_first_deposit_date_due, if: :first_deposit_days_after_psa_changed?
  before_update :set_second_deposit_date_due, if: :second_deposit_days_after_inspection_period_changed?
  before_update :set_closing_date, if: :closing_days_after_inspection_period_changed?

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
  def set_defaul_contract_deadline_date
    self.inspection_period_days = 30 if self.inspection_period_days.blank?
    
    if self.first_deposit_days_after_psa.blank?
      if DefaultValue.where(entity_name: 'TransactionTerm').where(attribute_name: 'FirstDepositDaysAfterPsa').first.present?
        self.first_deposit_days_after_psa = DefaultValue.where(entity_name: 'TransactionTerm').where(attribute_name: 'FirstDepositDaysAfterPsa').first.value.to_i if !self.first_deposit_days_after_psa.present?
      else
        #set manual default value
        self.first_deposit_days_after_psa = 3
      end    
    end

    if self.second_deposit_days_after_inspection_period.blank?
      if DefaultValue.where(entity_name: 'TransactionTerm').where(attribute_name: 'SecondDepositDaysAfterInspectionPeriod').first.present?
        self.second_deposit_days_after_inspection_period = DefaultValue.where(entity_name: 'TransactionTerm').where(attribute_name: 'SecondDepositDaysAfterInspectionPeriod').first.value.to_i
      else
        #set manual default value

      end
    end

    if self.closing_days_after_inspection_period.blank?
      if DefaultValue.where(entity_name: 'TransactionTerm').where(attribute_name: 'ClosingDaysAfterInspectionPeriod').first.present?
        self.closing_days_after_inspection_period = DefaultValue.where(entity_name: 'TransactionTerm').where(attribute_name: 'ClosingDaysAfterInspectionPeriod').first.value.to_i if !self.closing_days_after_inspection_period.present?
      else
        #set manual default value
        self.closing_days_after_inspection_period = 45
      end
    end

  end

  def set_first_deposit_days_after_psa
    if self.psa_date.present? && self.first_deposit_date_due.present?
      self.first_deposit_days_after_psa = self.first_deposit_date_due - self.psa_date
    end
  end

  def set_first_deposit_date_due 
    if self.psa_date.present?
      self.first_deposit_date_due = (self.psa_date + eval("#{self.first_deposit_days_after_psa.to_i}.days")).to_date
    else
      self.first_deposit_date_due = (Time.zone.now + eval("#{self.first_deposit_days_after_psa.to_i}.days")).to_date
    end
  end
    
  def set_second_deposit_days_after_inspection_period
    if self.psa_date.present? && self.second_deposit_date_due
      self.second_deposit_days_after_inspection_period = self.second_deposit_date_due - self.psa_date
    end
  end

  def set_second_deposit_date_due
    if self.second_deposit
      if self.psa_date.present?
        self.second_deposit_date_due = (self.psa_date + eval("#{self.second_deposit_days_after_inspection_period.to_i}.days") + 3.days).to_date
      else
        self.second_deposit_date_due = (Time.zone.now + eval("#{self.second_deposit_days_after_inspection_period.to_i}.days") + 3.days).to_date
      end
    end
  end 

    
  def set_closing_days_after_inspection_period
    if self.psa_date.present?
      self.closing_days_after_inspection_period = self.closing_date - self.psa_date
    end
  end

  def set_closing_date
    if self.psa_date.present?
      self.closing_date = (self.psa_date + eval("#{self.closing_days_after_inspection_period.to_i}.days")).to_date
    else
      self.closing_date = (Time.zone.now + eval("#{self.closing_days_after_inspection_period.to_i}.days")).to_date
    end
    
  end

end
