class CounteroffersController < ApplicationController
  respond_to :json

  def create
    @counteroffer = Counteroffer.new(counteroffer_params)
    if @counteroffer.save
      render json: {status: true, counteroffer_id: @counteroffer.id}
    else
      render json: false
    end
  end

  def destroy
    @counteroffer = Counteroffer.find(params[:id])
    if @counteroffer.destroy
      render json: true
    else
      render json: false
    end
    
  end

  def update
    @counteroffer = Counteroffer.find(params[:id])
    if @counteroffer.update(counteroffer_params)
      render json: { status: true, counteroffer: @counteroffer}
    else
      render json: { status: false }
    end
  end

  def counteroffer_params
    params.permit(:transaction_property_offer_id, :offered_date, :offer_type, :offered_price)
  end
end
