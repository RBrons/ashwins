class AddDocumentInGdriveToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :document_in_gdrive, :string
  end
end
