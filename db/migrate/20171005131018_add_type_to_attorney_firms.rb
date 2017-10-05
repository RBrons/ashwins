class AddTypeToAttorneyFirms < ActiveRecord::Migration[5.0]
  def change
    add_column :attorney_firms, :type_, :string, :default => 'Firm'
  end
end
