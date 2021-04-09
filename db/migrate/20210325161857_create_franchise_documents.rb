class CreateFranchiseDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :franchise_documents do |t|
    	t.references :franchise, foreign_key: true
    	t.string :description, null: false 
    	t.integer :document_type, null: false 
      t.timestamps
    end
  end
end
