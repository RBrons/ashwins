class RentTable < ApplicationRecord
  belongs_to :property

  def format_year
    if self.is_option
      "Rent for Option #{self.option_slab} (#{self.start_year} - #{self.end_year})"
    else
      "Rent for #{self.start_year} - #{self.end_year}"
    end
  end

  def format_rent
    "$ #{self.rent}"
  end

  def display_info
    if self.description.nil? || self.description.blank?
      self.format_year
    else
      self.description
    end
  end

end
