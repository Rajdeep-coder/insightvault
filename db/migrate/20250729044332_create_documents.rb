class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.text :extracted_text
      t.text :summary
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
