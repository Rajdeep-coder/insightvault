class CreateDocumentMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :document_messages do |t|
      t.references :document, null: false, foreign_key: true
      t.string :role
      t.text :content
      t.string :status

      t.timestamps
    end
  end
end
