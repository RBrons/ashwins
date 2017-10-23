class Admin::ClientsController < Admin::AdminController
  
  def resource_class_with_condition
    Client
  end
  
end