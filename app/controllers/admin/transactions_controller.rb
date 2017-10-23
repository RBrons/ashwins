class Admin::TransactionsController < Admin::AdminController
  
  def resource_class_with_condition
    if params[:klazz].blank?
      TransactionSale
    else
      params[:klazz].constantize
    end
  end
  
  def index
    @resources = resource_class_with_condition.with_deleted.joins(:transaction_main)
    @resources = @resources.where('transaction_mains.init' => false)
    @resources = @resources.where('transactions.deleted_at' => nil) unless params[:trashed].to_b
    @resources = @resources.where.not('transactions.deleted_at' => nil) if params[:trashed].to_b
    @resources = @resources.order('transactions.created_at DESC').paginate(page: params[:page], per_page: 10)
    
    respond_to do |format|
      format.html
    end
  
  end

end