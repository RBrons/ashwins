class AddAdditionalColumnsToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :lease_analysis_date, :date
    add_column :properties, :lease_original_landlord, :string
    add_column :properties, :lease_original_tenant, :string
    add_column :properties, :lease_original_guarantor, :string

    add_column :properties, :lease_primary_term, :integer
    add_column :properties, :lease_rent_commencement_date, :date
    add_column :properties, :lease_option_to_extend, :string
    add_column :properties, :lease_delivery_of_the_premises, :string

    add_column :properties, :lease_rent_abatement, :string
    add_column :properties, :lease_percentage_rent, :decimal
    add_column :properties, :lease_percentage_rent_exclusions, :string
    add_column :properties, :lease_percentage_rent_exist, :boolean

    add_column :properties, :survey, :string
    add_column :properties, :survey_described, :string
  end
end
