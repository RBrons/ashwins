class TransactionPropertyOffersController < ApplicationController

  respond_to :json

  def create
    @property_offer = TransactionPropertyOffer.new(transaction_property_offer_params)
    @purchaser = Contact.create(is_company: false)
    @property_offer.relinquishing_purchaser_contact_id = @purchaser.id
    if @property_offer.save
      render json: {status: true, offer_id: @property_offer.id, offer_name: @property_offer.offer_name, offeror_contact_id: @property_offer.relinquishing_purchaser_contact_id  }
    else
      render json: {status: false}
    end
  end

  def destroy
    @property_offer = TransactionPropertyOffer.find(params[:id])
    @purchaser = Contact.find(@property_offer.relinquishing_purchaser_contact_id)
    if @property_offer.destroy
      @purchaser.destroy

      render json: true
    else
      render json: false
    end
    
  end

  def update
    @property_offer = TransactionPropertyOffer.find(params[:id])
    if @property_offer.update(transaction_property_offer_params)
      if transaction_property_offer_params[:is_accepted] == true
        # set relinquishing_purchaser_contact_id in transaction
        
      end

      render json: { status: true, offer_name: @property_offer.offer_name }
    else
      render json: { status: false }
    end
  end

  def transaction_property_offer_params
    params.permit(:offer_name, :transaction_property_id, :is_accepted, :accepted_counteroffer_id)
  end
end
