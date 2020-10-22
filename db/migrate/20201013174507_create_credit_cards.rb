class CreateCreditCards < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_cards do |t|
    	t.references :franchise, foreign_key: true
    	t.string :card_type
    	t.string :last_four
    	t.integer :exp_year
    	t.integer :exp_month
    	t.string :card_token
    	t.string :slug, unique: true
    end
  end
end
