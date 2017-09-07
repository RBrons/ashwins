class TransactionPersonnel < ApplicationRecord

  belongs_to :contact
  belongs_to :transaction_sale

  FIXED_TITLE = ['Title', 'Survey', 'Environmental', 'Zoning']

  # def create_contact(t)
  #   self.contacts.find_by(object_title: t) || ContactOverride.create(object_title: t, type_id: self.id)
  # end

end

# class ContactOverride < ApplicationRecord
#   self.table_name = 'contacts'
# end
