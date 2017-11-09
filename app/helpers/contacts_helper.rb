module ContactsHelper
    def get_principals(contact_id, user_id)
        sale_transactions = TransactionSale.where(user_id: user_id).pluck(:id)
        purchase_transactions = TransactionPurchase.where(user_id: user_id).pluck(:id)
        transaction_ids = (sale_transactions + purchase_transactions)
        
        broker_offers = TransactionPropertyOffer.where(is_accepted: true).where(broker_contact_id: contact_id)
        attorney_offers = TransactionPropertyOffer.where(is_accepted: true).where(attorney_contact_id: contact_id)
        total_offers = (broker_offers + attorney_offers).uniq
        sellers = []
        buyers = []
        total_offers.each do |offer|
            transaction_property = offer.transaction_property
            if !transaction_property.is_sale
                if transaction_property.property.owner.present?
                    sellers << transaction_property.property.owner.name
                end
            else        
                buyers << offer.offer_name
            end
        end
        
        return [sellers.uniq, buyers.uniq]
    end
end
