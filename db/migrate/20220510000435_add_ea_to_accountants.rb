class AddEaToAccountants < ActiveRecord::Migration[6.1]
  def change
    add_column :accountants, :ea, :integer, default: 0
  end
end
