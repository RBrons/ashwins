class Counteroffer < ApplicationRecord
  belongs_to :transaction_property_offer, touch: true

end
