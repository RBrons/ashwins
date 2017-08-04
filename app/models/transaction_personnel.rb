class TransactionPersonnel < ApplicationRecord

  has_many :contacts, foreign_key: :type_id, primary_key: :id
  accepts_nested_attributes_for :contacts
  belongs_to :transaction_sale

  FIXED_TITLE = ['Seller`s Lawyer', 'Buyer`s Lawyer', 'Seller`s Broker', 'Buyer`s Broker', 'Title', 'Survey', 'Environmental', 'Zoning']

  def create_contacts
    FIXED_TITLE.each do |t|
      self.contacts.find_by(object_title: t) || ContactOverride.create(object_title: t, type_id: self.id)
    end
  end

end

class ContactOverride < ApplicationRecord
  self.table_name = 'contacts'
end
