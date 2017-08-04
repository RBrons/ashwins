class Tenant < ApplicationRecord

  belongs_to :user
  has_many :properties

  validates :name, presence: true, uniqueness: true,  allow_blank: false

end
