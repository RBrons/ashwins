class TransactionPropertyOffersController < ApplicationController

  def create
    @property_offer = TransactionPropertyOffer.new(transaction_property_offer_params)
    respond_to do |format|
      if @property_offer.save
        format.html { redirect_to :back } 
        format.json { render json: {status: true, offer_id: @property_offer.id, offer_name: @property_offer.offer_name, offeror_contact_id: @property_offer.client_contact_id  } }
      else
        format.html { redirect_to :back } 
        format.json { render json: {status: false} }
      end
    end
  end

  def destroy
    @property_offer = TransactionPropertyOffer.find(params[:id])
    offeror = @property_offer.offeror
    broker = @property_offer.broker
    attorney = @property_offer.attorney
    
    if @property_offer.destroy
      # delete broker and attorney related to this offer
      offeror.really_destroy! if offeror.present?
      broker.really_destroy! if broker.present?
      attorney.really_destroy! if attorney.present?
      
      render json: true
    else
      render json: false
    end
    
  end

  def update
    @property_offer = TransactionPropertyOffer.find(params[:id])
    @property_offer.update(transaction_property_offer_params)
    respond_to do |format|
      format.html { redirect_to :back } 
      format.json { render json: {status: true, offer_name: @property_offer.offer_name} }
    end
  end

  def update_with_contact
    @property_offer = TransactionPropertyOffer.find(params[:id])
    
    if !filter_contact_params.empty?
      if filter_contact_params[:id].present?
        Contact.find(filter_contact_params[:id]).update(filter_contact_params)
      else
        contact = Contact.create(filter_contact_params)
        if contact.role == 'Counter-Party'
          @property_offer.update(:client_contact_id => contact.id)
        elsif contact.role == 'Counter-Party Broker or Agent'
          @property_offer.update(:broker_contact_id => contact.id)
        elsif contact.role == 'Counter-Party Legal'
          @property_offer.update(:attorney_contact_id => contact.id)
        end
      end
    end
    
    if !transaction_property_offer_params.empty?
      @property_offer.update(transaction_property_offer_params)
    end

    respond_to do |format|
      format.html { redirect_to :back } 
      format.json { render json: {status: true, offer_name: @property_offer.offer_name} }
    end
    
  end

  def transaction_property_offer_params
    params.require(:transaction_property_offer).permit(:offer_name, :transaction_property_id, :is_accepted, :accepted_counteroffer_id)
  end

  def filter_contact_params
    filter_params = params.require(:transaction_property_offer).require(:contact).permit!
    filter_params[:user_id] = current_user.id
    if filter_params[:is_company] == "true"
      filter_params[:first_name] = nil
      filter_params[:last_name] = nil
    else
      filter_params[:company_name] = nil
    end
    
    filter_params
  end

end
