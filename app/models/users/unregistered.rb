class Users::Unregistered < ApplicationRecord
  self.table_name = 'users_unregistered'

  after_save :add_key

  def add_key
    if self.key.blank?
      self.update_column(:key, Key.unused_key)
    end
  end

end
