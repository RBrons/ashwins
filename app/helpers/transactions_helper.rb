module TransactionsHelper
    def get_transaction_properties(trans_main_id, property_type = 'sale')
        if property_type == 'sale'
            is_sale = true
        elsif property_type == 'purchase'
            is_sale = false
            else
                is_sale = 'undefined'
        end
        
        if is_sale != 'undefined'
            transaction_property_ids = TransactionProperty.where(transaction_main_id: trans_main_id, is_sale: is_sale).pluck(:property_id)
            properties = Property.where(id: transaction_property_ids).order(created_at: :desc)
        else
            properties = nil 
        end
        
        return properties
    end

    def get_property_step(property_id, trans_main_id, is_sale = true)
        cur_step = TransactionProperty.where(property_id: property_id).where(transaction_main_id: trans_main_id).where(is_sale: is_sale).first

        return cur_step
    end

    def get_property(property_id)
        return Property.find(property_id)
    end
    
    def get_recent_counteroffer_price(transaction_property_offer)
        last_offered_price = transaction_property_offer.counteroffers.where("offered_price IS NOT NULL AND offered_date IS NOT NULL").order(updated_at: :asc).last.try(:offered_price)
        if last_offered_price
            return number_to_currency(last_offered_price)
        else
            return ""
        end
    end

    def get_transaction_property_offeror(transaction_property_offer)
        @purchaser = Contact.where(id: transaction_property_offer.relinquishing_purchaser_contact_id).first 
        if @purchaser.present?
            return Contact.where(id: transaction_property_offer.relinquishing_purchaser_contact_id).first
        else
            @purchaser = Contact.create(is_company: false)
            transaction_property_offer.update(relinquishing_purchaser_contact_id: @purchaser.id)
            return @purchaser
        end
    end

    def get_relinquishing_property_purchaser(property_id, transaction_id)
        transaction_property = TransactionProperty.where(property_id: property_id).where(transaction_id: transaction_id).where(is_sale: true).first
        if transaction_property.present?
            accepted_offer = transaction_property.transaction_property_offers.where(is_accepted: true).first
            if accepted_offer.present?
                return Contact.find(accepted_offer.relinquishing_purchaser_contact_id)
            else
                return false
            end
        else
            return false
        end
    end

    def get_sale_price(transaction_property)
        accepted_offer = transaction_property.transaction_property_offers.where(is_accepted: true).first
        if accepted_offer.present?
            if accepted_offer.accepted_counteroffer_id == 0
                return transaction_property.sale_price
            else
                return Counteroffer.find(accepted_offer.accepted_counteroffer_id).try(:offered_price)
            end
        else
            return ''
        end
    end
    
    def is_property_closed?(transaction_id, property_id)
      retVal = false
      p = TransactionProperty.where(transaction_id: transaction_id, property_id: property_id).first
      retVal = p.closed? if !p.nil?
      return retVal
    end

end
