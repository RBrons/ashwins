class TransactionBasketsController < ApplicationController

  respond_to :json

  def create
    @transaction_basket = TransactionBasket.new({basket_name: params[:basket_name], transaction_id: params[:transaction_id], identification_rule: '200%'})
    
    if @transaction_basket.save
      params[:property_ids].each do |property_id|
        @transaction_basket.transaction_basket_properties.create(:property_id => property_id)
      end
      render json: {status: true, basket: @transaction_basket }
    else
      render json: {status: false}
    end
  end

  def destroy
    @transaction_basket = TransactionBasket.find(params[:id])
    
    if @transaction_basket.destroy
      render json: true
    else
      render json: false
    end
    
  end

  def update
    @transaction_basket = TransactionBasket.find(params[:id])
    if @transaction_basket.transaction_basket_properties.destroy_all
      params[:property_ids].each do |property_id|
        @transaction_basket.transaction_basket_properties.create(:property_id => property_id)
      end
      render json: { status: true, basket: @transaction_basket }
    else
      render json: { status: false }
    end
  end

end
