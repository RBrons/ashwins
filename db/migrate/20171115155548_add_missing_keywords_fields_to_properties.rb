class AddMissingKeywordsFieldsToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :taxes_and_fees_additional_rent_keywords, :string
    add_column :properties, :taxes_and_fees_net_nature_keywords, :string
    add_column :properties, :premises_quiet_enjoyment_keywords, :string
  end
end
