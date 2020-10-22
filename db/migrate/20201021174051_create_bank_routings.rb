class CreateBankRoutings < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_routings do |t|
    	t.string :routing
    	t.string :office_code
    	t.string :fbr
    	t.string :record_type
    	t.string :change_date
    	t.string :new_routing
    	t.string :name
    	t.string :address
    	t.string :city
    	t.string :state
    	t.string :zip
    	t.string :zip_ext
    	t.string :area_code
    	t.string :prefix
    	t.string :suffix
    	t.string :status_code
    	t.string :master_state

    end
  end
end
