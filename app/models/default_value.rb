class DefaultValue < ApplicationRecord

  PROPERTY_OPTIONS = ["Amount", "Date", "String", "Integer", "Random US City",
                      "Random Tenant", "Random Rent", "Random Offerror",
                      "Random Cap Rate", "Random Owner", "Random Seller"]

  TRANSACTION_TERM_OPTIONS = ["Amount", "Date", "String", "Integer"]

  def self.property_options
      return PROPERTY_OPTIONS
  end

  def self.transaction_term_options
    return TRANSACTION_TERM_OPTIONS
  end

end
