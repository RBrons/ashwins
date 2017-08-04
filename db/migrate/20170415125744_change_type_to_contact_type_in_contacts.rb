class ChangeTypeToContactTypeInContacts < ActiveRecord::Migration[5.0]
  def change
    if column_exists? :contacts, :company_role
      rename_column :contacts, :company_role, :role
    end

    if column_exists? :contacts, :type
      rename_column :contacts, :type, :contact_type
    end

    add_column :contacts, :is_company, :boolean, default: false
  end
end
