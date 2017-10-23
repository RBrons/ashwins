class Procedure::Action < ApplicationRecord
  include MyFunction
  after_save :add_key
  has_many :checklists, :class_name => 'Procedure::Action::Checklist'


  def access_resources
    AccessResource.where(resource_klass: self.class.to_s, resource_id: self.id)
  end

end
