module ContactsHelper
    def get_principals(contact_id, user_id)
        sale_transactions = TransactionSale.where(user_id: user_id).pluck(:id)
        purchase_transactions = TransactionPurchase.where(user_id: user_id).pluck(:id)
        transaction_ids = (sale_transactions + purchase_transactions)

        broker_transaction_properties = TransactionProperty.where(broker_id: contact_id).where(transaction_id: transaction_ids)
        attorney_transaction_properties = TransactionProperty.where(attorney_id: contact_id).where(transaction_id: transaction_ids)
        owing_transaction_properties = (broker_transaction_properties + attorney_transaction_properties).uniq
        sellers = []
        buyers = []
        owing_transaction_properties.each do |transaction_property|
            if !transaction_property.is_sale
                if transaction_property.property.owner.present?
                    sellers << transaction_property.property.owner.name
                end
            else        
                buyer = transaction_property.transaction_property_offers.where(is_accepted: true).first
                if buyer.present?
                    buyers << buyer.offer_name
                end
            end
        end
        
        return [sellers.uniq, buyers.uniq]
    end
end
