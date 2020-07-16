class AddUserEmailToEventLogs < ActiveRecord::Migration[6.0]
  def change
  	add_column :event_logs, :user_email, :string, null: :false
  end
end
