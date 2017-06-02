class RentTable < ApplicationRecord
  belongs_to :property

  def format_year
    if self.is_option
      "Option #{self.option_slab} (#{self.start_year} - #{self.end_year})"
    else
      "#{self.start_year} - #{self.end_year}"
    end
  end

  def format_rent
    "$ #{self.rent}"
  end
end
