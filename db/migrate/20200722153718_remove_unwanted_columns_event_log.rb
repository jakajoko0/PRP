class RemoveUnwantedColumnsEventLog < ActiveRecord::Migration[6.0]
  def change
  	remove_column :event_logs, :franchise_id
  	remove_column :event_logs, :email
  end
end
