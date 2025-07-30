class AddStatusToDocuments < ActiveRecord::Migration[8.0]
  def change
    add_column :documents, :status, :string
  end
end
