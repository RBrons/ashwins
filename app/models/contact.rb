class Contact < ApplicationRecord

  acts_as_paranoid

  has_many :groups, :through => :group_members, :as => :gmember
  has_many :group_members, :as => :gmember

  has_one :transaction_property_offer, foreign_key: :relinquishing_purchaser_contact_id, dependent: :destroy
  
  has_many :transaction_personnels, dependent: :destroy

  #validates_presence_of :first_name, :last_name #, :email
  validate :email_check
  validate :company_name_check

  attr_accessor :name, :per_role, :cp_role, :cprefix

  # has_one :people_and_firm

  PERSONNEL_ROLE = ["Counter-Party Broker or Agent",
          "Counter-Party Legal",
          "Counter-Party Consultant",
          "Tenant",
          "Tenant Broker or Agent",
          "Tenant Legal",
          "Tenant Consultant",
          "Lendor",
          "Lendor Broker or Agent",
          "Lendor Legal",
          "Lendor Consultant",
          "Environmental Consultant",
          "Surveyor",
          "Zoning Consultant",
          "Title Company",
          "Qualified Intermediary",
          "Legal Consultant",
          "Accountant",
          "Other Consultant"]

CLIENT_PARTICIPANT_ROLE = ["Principal",
          "Agent",
          "Judge",
          "Guardian",
          "Ward",
          "Settlor",
          "Trustee",
          "Beneficiary",
          "LLC Member",
          "LLC Outside Manager",
          "LP General Partner",
          "LP Limited Partner",
          "Partner",
          "Limited Liability Partner",
          "Corporate Director",
          "Corporate Officer",
          "Corporate Stockholder",
          "Tenant in Common",
          "Tenant by Entirety",
          "Joint Tenant"]

  def self.prospective_entity
    where("role != ? OR client_type is NULL", "Counter-Party")
  end

  def self.prospective_person
    where(role: "Counter-Party")
  end

  # Views
  def name
    if !company_name.nil? && !company_name.blank?
       "#{self.company_name} #{self.legal_ending}"
    else
      "#{self.first_name.capitalize unless self.first_name.nil?} #{self.last_name.capitalize unless self.last_name.nil?}"
    end
  end

  def is_company?
    self.is_company
  end
    
  private
  
  def company_name_check
    if self.is_company? && !self.company_name.present?
      errors.add(:company_name, ' can\'t be blank!')
      return false
    end
  end

  def email_check
    if self.email.present? && !self.email.email?
      errors.add(:email, ' is invalid !')
    end
  end

  def self.TransactionContacts(type_="individual")
    if type_ == "company"
      @contacts = Contact.where('role ilike ? and company_name is not null', "Counter-Party")
    elsif type_ == "individual"
      @contacts = Contact.where('role ilike ? and company_name is null', "Counter-Party")
    else
      @contacts = Contact.where('role ilike ? ', "Counter-Party")
    end
    ret = []
    @contacts.each { |contact|
      cname = contact.try(:company_name) || ""
      if cname.blank?
        cname = contact.first_name + ' ' + contact.last_name
      end
      ret.push([cname, contact.id])
    }
    return ret
  end


end
