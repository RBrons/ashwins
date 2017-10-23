class DefaultValue < ApplicationRecord

  attr_accessor :random_mode

  PROPERTY_OPTIONS = ["Amount", "Date", "String", "Integer", "Random US City",
                      "Random Tenant", "Random Rent",
                      "Random Cap Rate", "Random Owner"]

  TRANSACTION_TERM_OPTIONS = ["Amount", "Date", "String", "Integer"]

  TRANSACTION_PROPERTY_OPTIONS = ["Amount", "Date", "String", "Integer"]

  TRANSACTION_SALE_OPTIONS = ["Amount", "Date", "String", "Integer", "Random Seller"]

  RANDOM_MODE = [{entity: 'Property', attribute: 'LocationCity', vtype: 'Random US City'},
                 {entity: 'Property', attribute: 'TenantId', vtype: 'Random Tenant'},
                 {entity: 'Property', attribute: 'CapRate', vtype: 'Random Cap Rate'},
                 {entity: 'Property', attribute: 'CurrentRent', vtype: 'Random Rent'},
                 {entity: 'Property', attribute: 'OwnerEntityId', vtype: 'Random Owner'},
                 {entity: 'RandomMode', attribute: 'Random', vtype: 'True'}
                ]

  def self.property_options
      return PROPERTY_OPTIONS
  end

  def self.transaction_term_options
    return TRANSACTION_TERM_OPTIONS
  end

  def self.transaction_property_options
    return TRANSACTION_PROPERTY_OPTIONS
  end

  def self.transaction_sale_options
    return TRANSACTION_SALE_OPTIONS
  end

end
