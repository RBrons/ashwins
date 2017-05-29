class TransactionSale < ApplicationRecord
  self.table_name = 'transactions'
  
  acts_as_paranoid
  
  include MyFunction  
  
  enum type_is: { '1031 Exchange' => 0 }
  
  default_scope -> { where(is_purchase: 0) }

  attr_accessor :relqn_seller_entity_id, :relqn_purchaser_contact_id, 
    :prop_owner, :prop_status, :entity_info, :closing_date, :closing_proceeds
  
  has_many :comments, as: :commentable
  belongs_to :property
  belongs_to :client
  has_one :qualified_intermediary, foreign_key: :transaction_id
  has_many :transaction_status, foreign_key: :transaction_id
  
  has_many :transaction_properties, foreign_key: :transaction_id
  accepts_nested_attributes_for :transaction_properties, :reject_if => :all_blank, allow_destroy: true
  
  has_one :transaction_term, foreign_key: :transaction_id, dependent: :destroy
  accepts_nested_attributes_for :transaction_term, :reject_if => :all_blank

  has_one :transaction_personnel, foreign_key: :transaction_id
  
  has_one :entity
  has_one :contact
  
  belongs_to :transaction_main
  
  belongs_to :relinquishing_seller_entity, class_name: 'Entity'
  belongs_to :relinquishing_purchaser_contact, class_name: 'Contact'
  
  delegate :purchase_only?, to: :main, allow_nil: true
  delegate :has_purchase?, to: :main, allow_nil: true
  delegate :has_sale?, to: :main, allow_nil: true
  
  delegate :closing_date, to: :transaction_term, allow_nil: true
  delegate :first_deposit_date_due, to: :transaction_term, allow_nil: true
  delegate :inspection_period_days, to: :transaction_term, allow_nil: true
  delegate :psa_date, to: :transaction_term, allow_nil: true
  delegate :closing_date, to: :transaction_term, allow_nil: true
  delegate :second_deposit_date_due, to: :transaction_term, allow_nil: true
  
  def term
    @term ||= transaction_term
  end
  
  def main
    @main ||= transaction_main
  end
  
  def purchase_only?
    false
  end
  
  after_create :access_resource
  after_save :add_key
  
  #validate :seller_and_purchaser_match
  
  validates_presence_of :relinquishing_seller_entity_id #, if: '!self.seller_person_is?', message: 'Relinquishing Seller`s Entity can not be blank'
  
  #validates_presence_of :relinquishing_seller_first_name, if: 'self.seller_person_is?', message: 'Relinquishing Seller first name can not be blank'
  #validates_presence_of :relinquishing_seller_last_name, if: 'self.seller_person_is?', message: 'Relinquishing Seller last name can not be blank'
  
  #validates_presence_of :relinquishing_purchaser_first_name, if: 'self.purchaser_person_is?', message: 'Relinquishing Purchaser first name can not be blank'
  #validates_presence_of :relinquishing_purchaser_last_name, if: 'self.purchaser_person_is?', message: 'Relinquishing Purchaser last name can not be blank'
  
  def qualified_intermediary
    super || create_qualified_intermediary
  end
  
  def get_sale_purchase_text
    if self.Sale?
      'sale'
    elsif self.Purchase?
      'purchase'
    end
  end
  
  def end_of_inspection
    if psa_date.present? && inspection_period_days.present?
      psa_date + eval("#{inspection_period_days}.days")
    end
  end
  
  def purchaser_name
    if !self.purchaser_person_is?
      self.relinquishing_purchaser_contact.try(:name)
    else
      "#{self.relinquishing_purchaser_first_name} #{self.relinquishing_purchaser_last_name}"
    end
  end
  
  def seller_name
    return self.relinquishing_seller_entity.try(:name)
    if !self.seller_person_is?
      self.relinquishing_seller_entity.try(:name)
    else
      "#{self.relinquishing_seller_first_name} #{self.relinquishing_seller_last_name}"
    end
  end
  
  def Sale?
    if self.is_a?(TransactionSale)
      true
    elsif self.is_a?(TransactionPurchase)
      false
    end
  end
  
  def Purchase?
    !Sale?
  end
  
  private
  def seller_and_purchaser_match
    ## Seller is an Entity and Purchaser is a Contact
    return true  
  end
  
  public
  def seller_info
    if self.seller_person_is?
      "#{ self.relinquishing_seller_first_name } #{ self.relinquishing_seller_last_name}"
    else
      self.relinquishing_seller_entity.try(:name)
    end
  end
  
  # Views
  def city_state
    "#{self.city} #{self.state}"
  end
  
  def created_at_to_string
    created_at.to_string
  end
  
  def delete_url
    Rails.application.routes.url_helpers.admin_transaction_path(self, klazz: self.class.to_s)
  end
  
  def self.resources_url
    Rails.application.routes.url_helpers.admin_transactions_path(klazz: self.to_s)
  end
  
  def self.view_index_columns
    [
      { show: 'Seller', call: 'seller_name' },
      # { show: 'Relinquished Property | Properties', call: 'purchaser_name' },
      { show: 'Date of PSA', call: 'psa_date' },
      { show: 'Days to 1st Deposit', eval: "'Measured: ' + (elem.first_deposit_date_due.try(:days_gone) || '').to_s + ' Days'" },
      { show: 'Days to End of Inspection', eval: "'Measured: ' + (elem.end_of_inspection.try(:days_gone) || '').to_s + ' Days'" },
      { show: 'Days to 2nd Deposit', eval: "'Measured: ' + (elem.second_deposit_date_due.try(:days_gone) || '').to_s + ' Days'" },
      { show: 'Days to Closing', eval: "'Measured: ' + (elem.closing_date.try(:days_gone) || '').to_s + ' Days'" },
      { show: 'Created', call: 'created_at_to_string' },
    ]
  end

end
