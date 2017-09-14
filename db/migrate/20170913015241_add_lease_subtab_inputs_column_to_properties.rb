class AddLeaseSubtabInputsColumnToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :taxes_and_fees_restate, :string
    add_column :properties, :taxes_and_fees_assessments, :string
    add_column :properties, :taxes_and_fees_separate_tax_parcel, :string
    add_column :properties, :taxes_and_fees_landlord_contesting, :string
    add_column :properties, :taxes_and_fees_tenant_contesting, :string
    add_column :properties, :taxes_and_fees_easements, :string

    add_column :properties, :site_preparation_env_obligations, :string
    add_column :properties, :site_preparation_env_termination_rights, :string
    add_column :properties, :site_preparation_env_remediation, :string
    add_column :properties, :site_preparation_env_permits_and_licenses, :string

    add_column :properties, :construction, :string
    add_column :properties, :construction_deadline, :string
    add_column :properties, :construction_liens, :string
    add_column :properties, :construction_approval_of_plans_and_specs, :string

    add_column :properties, :use_clause, :string
    add_column :properties, :use_exclusive_clause, :string

    add_column :properties, :premises_tenant_rights, :string
    add_column :properties, :premises_waste, :string
    add_column :properties, :premises_initial_opening, :string
    add_column :properties, :premises_recapture_clause, :string
    add_column :properties, :premises_demolition, :string
    add_column :properties, :premises_tenants_equipment_defined, :string
    add_column :properties, :premises_ownership_and_removal, :string
    add_column :properties, :premises_repairs, :string
    add_column :properties, :premises_compliance_with_laws, :string
    add_column :properties, :premises_surrender, :string
    add_column :properties, :premises_inspection, :string
    add_column :properties, :premises_insurance, :string
    add_column :properties, :premises_destruction, :string
    add_column :properties, :premises_total_taking, :string
    add_column :properties, :premises_partial_taking, :string
    add_column :properties, :premises_signs, :string
    add_column :properties, :premises_utilities, :string

    add_column :properties, :transfer_assignment_and_subletting, :string
    add_column :properties, :transfer_leasehold_mortgage, :string
    add_column :properties, :transfer_subordination, :string
    add_column :properties, :transfer_estoppel_certificate, :string

    add_column :properties, :remedies_rent_defaults, :string
    add_column :properties, :remedies_landlord, :string
    add_column :properties, :remedies_mitigation, :string
    add_column :properties, :remedies_force_majeure, :string
    add_column :properties, :remedies_dispute_resolution, :string
    add_column :properties, :remedies_landlord_exoneration, :string
    add_column :properties, :remedies_exculpation, :string

    add_column :properties, :misc_notices, :string
    add_column :properties, :misc_obligation, :string
  end
end
