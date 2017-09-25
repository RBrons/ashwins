class AddKeywordsFieldsToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :lease_rent_abatement_keywords, :string
    add_column :properties, :lease_percentage_rent_exclusions_keywords, :string

    add_column :properties, :taxes_and_fees_restate_keywords, :string
    add_column :properties, :taxes_and_fees_assessments_keywords, :string
    add_column :properties, :taxes_and_fees_separate_tax_parcel_keywords, :string
    add_column :properties, :taxes_and_fees_landlord_contesting_keywords, :string
    add_column :properties, :taxes_and_fees_tenant_contesting_keywords, :string
    add_column :properties, :taxes_and_fees_easements_keywords, :string

    add_column :properties, :site_preparation_env_obligations_keywords, :string
    add_column :properties, :site_preparation_env_termination_rights_keywords, :string
    add_column :properties, :site_preparation_env_remediation_keywords, :string
    add_column :properties, :site_preparation_env_permits_and_licenses_keywords, :string

    add_column :properties, :construction_keywords, :string
    add_column :properties, :construction_deadline_keywords, :string
    add_column :properties, :construction_liens_keywords, :string
    add_column :properties, :construction_approval_of_plans_and_specs_keywords, :string

    add_column :properties, :use_clause_keywords, :string
    add_column :properties, :use_exclusive_clause_keywords, :string

    add_column :properties, :premises_tenant_rights_keywords, :string
    add_column :properties, :premises_waste_keywords, :string
    add_column :properties, :premises_initial_opening_keywords, :string
    add_column :properties, :premises_recapture_clause_keywords, :string
    add_column :properties, :premises_demolition_keywords, :string
    add_column :properties, :premises_tenants_equipment_defined_keywords, :string
    add_column :properties, :premises_ownership_and_removal_keywords, :string
    add_column :properties, :premises_repairs_keywords, :string
    add_column :properties, :premises_compliance_with_laws_keywords, :string
    add_column :properties, :premises_surrender_keywords, :string
    add_column :properties, :premises_inspection_keywords, :string
    add_column :properties, :premises_insurance_keywords, :string
    add_column :properties, :premises_destruction_keywords, :string
    add_column :properties, :premises_total_taking_keywords, :string
    add_column :properties, :premises_partial_taking_keywords, :string
    add_column :properties, :premises_signs_keywords, :string
    add_column :properties, :premises_utilities_keywords, :string

    add_column :properties, :transfer_assignment_and_subletting_keywords, :string
    add_column :properties, :transfer_leasehold_mortgage_keywords, :string
    add_column :properties, :transfer_subordination_keywords, :string
    add_column :properties, :transfer_estoppel_certificate_keywords, :string

    add_column :properties, :remedies_rent_defaults_keywords, :string
    add_column :properties, :remedies_landlord_keywords, :string
    add_column :properties, :remedies_mitigation_keywords, :string
    add_column :properties, :remedies_force_majeure_keywords, :string
    add_column :properties, :remedies_dispute_resolution_keywords, :string
    add_column :properties, :remedies_landlord_exoneration_keywords, :string
    add_column :properties, :remedies_exculpation_keywords, :string

    add_column :properties, :misc_notices_keywords, :string
    add_column :properties, :misc_obligation_keywords, :string
  end
end
