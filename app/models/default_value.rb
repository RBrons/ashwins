class DefaultValue < ApplicationRecord

  PROPERTY_OPTIONS = ["Amount", "Date", "String", "Random US City",
                      "Random Tenant", "Random Rent", "Random Offerror",
                      "Random Cap Rate", "Random Owner", "Random Seller"]

  def self.property_options
      return PROPERTY_OPTIONS
  end

end
