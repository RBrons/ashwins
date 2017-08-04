class Procedure < ApplicationRecord
  include MyFunction

  has_many :actions, :class_name => 'Procedure::Action', foreign_key: 'procedure_id'
  belongs_to :property
  after_save :add_key

  validates_presence_of :title
  validates_length_of :title, maximum: 78

end
