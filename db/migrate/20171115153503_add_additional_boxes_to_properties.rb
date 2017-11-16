class AddAdditionalBoxesToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :taxes_and_fees_additional_rent, :string
    add_column :properties, :taxes_and_fees_additional_rent_rating, :string
    add_column :properties, :taxes_and_fees_additional_rent_section, :string

    add_column :properties, :taxes_and_fees_net_nature, :string
    add_column :properties, :taxes_and_fees_net_nature_rating, :string
    add_column :properties, :taxes_and_fees_net_nature_section, :string

    add_column :properties, :premises_quiet_enjoyment, :string
    add_column :properties, :premises_quiet_enjoyment_rating, :string
    add_column :properties, :premises_quiet_enjoyment_section, :string

    # For section box fields of existing boxes.
    add_column :properties, :lease_rent_abatement_section, :string
    add_column :properties, :lease_percentage_rent_exclusions_section, :string
    add_column :properties, :taxes_and_fees_restate_section, :string
    add_column :properties, :taxes_and_fees_assessments_section, :string
    add_column :properties, :taxes_and_fees_separate_tax_parcel_section, :string
    add_column :properties, :taxes_and_fees_landlord_contesting_section, :string
    add_column :properties, :taxes_and_fees_tenant_contesting_section, :string
    add_column :properties, :taxes_and_fees_easements_section, :string
    add_column :properties, :site_preparation_env_obligations_section, :string
    add_column :properties, :site_preparation_env_termination_rights_section, :string
    add_column :properties, :site_preparation_env_remediation_section, :string
    add_column :properties, :site_preparation_env_permits_and_licenses_section, :string
    add_column :properties, :construction_section, :string
    add_column :properties, :construction_deadline_section, :string
    add_column :properties, :construction_liens_section, :string
    add_column :properties, :construction_approval_of_plans_and_specs_section, :string
    add_column :properties, :use_clause_section, :string
    add_column :properties, :use_exclusive_clause_section, :string
    add_column :properties, :premises_tenant_rights_section, :string
    add_column :properties, :premises_waste_section, :string
    add_column :properties, :premises_initial_opening_section, :string
    add_column :properties, :premises_recapture_clause_section, :string
    add_column :properties, :premises_demolition_section, :string
    add_column :properties, :premises_tenants_equipment_defined_section, :string
    add_column :properties, :premises_ownership_and_removal_section, :string
    add_column :properties, :premises_repairs_section, :string
    add_column :properties, :premises_compliance_with_laws_section, :string
    add_column :properties, :premises_surrender_section, :string
    add_column :properties, :premises_inspection_section, :string
    add_column :properties, :premises_insurance_section, :string
    add_column :properties, :premises_destruction_section, :string
    add_column :properties, :premises_total_taking_section, :string
    add_column :properties, :premises_partial_taking_section, :string
    add_column :properties, :premises_signs_section, :string
    add_column :properties, :premises_utilities_section, :string
    add_column :properties, :transfer_assignment_and_subletting_section, :string
    add_column :properties, :transfer_leasehold_mortgage_section, :string
    add_column :properties, :transfer_subordination_section, :string
    add_column :properties, :transfer_estoppel_certificate_section, :string
    add_column :properties, :remedies_rent_defaults_section, :string
    add_column :properties, :remedies_landlord_section, :string
    add_column :properties, :remedies_mitigation_section, :string
    add_column :properties, :remedies_dispute_resolution_section, :string
    add_column :properties, :remedies_landlord_exoneration_section, :string
    add_column :properties, :remedies_exculpation_section, :string
    add_column :properties, :misc_notices_section, :string
    add_column :properties, :misc_obligation_section, :string
  end
end
