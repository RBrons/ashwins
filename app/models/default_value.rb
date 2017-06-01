class DefaultValue < ApplicationRecord

  PROPERTY_OPTIONS = ["Amount", "Date", "String", "Integer", "Random US City",
                      "Random Tenant", "Random Rent", "Random Offerror",
                      "Random Cap Rate", "Random Owner", "Random Seller"]

  TRANSACTION_TERM_OPTIONS = ["Amount", "Date", "String", "Integer"]

  TRANSACTION_PROPERTY_OPTIONS = ["Amount", "Date", "String", "Integer"]

  TRANSACTION_SALE_OPTIONS = ["Amount", "Date", "String", "Integer", "Random Seller"]

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
