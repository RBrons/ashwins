class TransactionPurchase < ApplicationRecord
  self.table_name = 'transactions'
  
  acts_as_paranoid
  
  include MyFunction
  
  enum type_is: { '1031 Exchange' => 0 }
  
  default_scope -> { where(is_purchase: 1) }

  attr_accessor :rplmnt_seller_contact_id, :rplmnt_purchaser_entity_id, 
    :prop_owner, :prop_status, :entity_info
  
  has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :property
  belongs_to :client

  has_one :qualified_intermediary, foreign_key: :transaction_id, dependent: :destroy
  has_many :transaction_status, foreign_key: :transaction_id, dependent: :destroy
  
  has_many :transaction_properties, foreign_key: :transaction_id, dependent: :destroy
  accepts_nested_attributes_for :transaction_properties, :reject_if => :all_blank, allow_destroy: true

  has_many :transaction_baskets, foreign_key: :transaction_id, dependent: :destroy
  accepts_nested_attributes_for :transaction_baskets, :reject_if => :all_blank, allow_destroy: true
  
  has_one :transaction_term, foreign_key: :transaction_id, dependent: :destroy
  accepts_nested_attributes_for :transaction_term, :reject_if => :all_blank
  
  has_one :transaction_personnel, foreign_key: :transaction_id, dependent: :destroy
  
  has_one :entity
  has_one :contact
  
  belongs_to :transaction_main
  
  belongs_to :replacement_seller_contact, class_name: 'Contact'
  belongs_to :replacement_purchaser_entity, class_name: 'Entity'
  
  after_create :access_resource
  after_save :add_key
  
  #validate :seller_and_purchaser_match
  
  validates_presence_of :replacement_purchaser_entity_id #, if: '!self.purchaser_person_is?', message: 'Replacement Purchaser`s Entity can not be blank'
  
  #validates_presence_of :replacement_seller_first_name, if: 'self.seller_person_is?', message: "Replacement Seller's first name can not be blank"
  #validates_presence_of :replacement_seller_last_name, if: 'self.seller_person_is?', message: "Replacement Seller's last name can not be blank"
  
  #validates_presence_of :replacement_purchaser_first_name, if: 'self.purchaser_person_is?', message: "Replacement Purchaser's first name can not be blank"
  #validates_presence_of :replacement_purchaser_last_name, if: 'self.purchaser_person_is?', message: "Replacement Purchaser's last name can not be blank"
  
  validates_presence_of :purchase_only_closing_date, if: 'self.purchase_only?', message: 'Closing Date can not be blank'
  validates_presence_of :purchase_only_qi_funds, if: 'self.purchase_only?', message: 'QI Funds can not be blank'
  
  delegate :purchase_only?, to: :transaction_main
  
  
  delegate :sale, to: :main, allow_nil: true
  delegate :has_purchase?, to: :main, allow_nil: true
  delegate :has_sale?, to: :main, allow_nil: true
  
  delegate :currently_held, to: :qualified_intermediary, allow_nil: true
  
  delegate :first_deposit_date_due, to: :term, allow_nil: true
  delegate :inspection_period_days, to: :term, allow_nil: true
  delegate :closing_date, to: :term, allow_nil: true
  delegate :psa_date, to: :term, allow_nil: true
  delegate :closing_date, to: :term, allow_nil: true
  delegate :second_deposit_date_due, to: :term, allow_nil: true
  
  alias_attribute :qi_fund, :purchase_only_qi_funds
  
  def term
    @term ||= transaction_term
  end
  
  def main
    @main ||= transaction_main
  end
  
  def days_45
    if closing_date.present?
      closing_date + 45.days
    end
  end
  
  def days_180
    if closing_date.present?
      closing_date + 180.days
    end
  end
  
  def end_of_inspection
    if psa_date.present? && inspection_period_days.present?
      psa_date + eval("#{inspection_period_days}.days")
    end
  end
  
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
  
  def purchaser_name
    return self.replacement_purchaser_entity.try(:name)
    if !self.purchaser_person_is?
      self.replacement_purchaser_entity.try(:name)
    else
      "#{self.replacement_purchaser_first_name} #{self.replacement_purchaser_last_name}"
    end
  end
  
  def seller_name
    if !self.seller_person_is?
      self.replacement_seller_contact.try(:name)
    else
      "#{self.replacement_seller_first_name} #{self.replacement_seller_last_name}"
    end
  end
  
  def funds_identified
    (currently_held || 0)
  end
  
  def funds_to_identified
    (qi_fund || 0) - (currently_held || 0)
  end
  
  private
  def seller_and_purchaser_match
    ## Seller is an Entity and Purchaser is a Contact
    return true  
  end

  public
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

  def __first_deposit_date_due__
    "Measured: #{ (first_deposit_date_due.days_gone rescue '') } Days"
  end
  
  def closing_date_to_string
    closing_date.to_string rescue ''
  end

  def self.view_index_columns
    [
      { show: 'Buyer', call: 'purchaser_name' },
      { show: 'Seller', call: 'seller_name' },
      # { show: 'Relinquished Property | Properties', call: 'purchaser_name' },
      { show: 'Closing Date', call: 'closing_date_to_string' },
      { show: 'QI Funds', eval: 'number_to_currency(elem.qi_fund)' },
      { show: 'Funds Identified', eval: 'number_to_currency(elem.funds_identified)' },
      { show: 'Funds to be Identified', eval: 'number_to_currency(elem.funds_to_identified)' },
      { show: 'Date of PSA', eval: 'elem.psa_date.try(:to_string)' },
      { show: 'Days to 45', eval: 'elem.days_45.try(:to_string)' },
      { show: 'Days to 180', eval: 'elem.days_180.try(:to_string)' },
      { show: 'Days to 1st Deposit', eval: "elem.first_deposit_date_due.try(:days_gone)" },
      { show: 'Days to End of Inspection', eval: "elem.end_of_inspection.try(:to_string)" },
      { show: 'Days to 2nd Deposit', eval: "elem.second_deposit_date_due.try(:days_gone)" },
      { show: 'Days to Closing', eval: "elem.closing_date.try(:days_gone)"},
      { show: 'Created', call: 'created_at_to_string' },
    ]
  end


end
