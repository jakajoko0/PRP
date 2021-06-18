# frozen_string_literal: true
class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :timeoutable

  enum role: %i[full_control read_only]

  after_initialize :set_default_role, if: :new_record?

  after_create :log_event

  def set_default_role
    self.role ||= :read_only
  end

  def reset_pass
    send_reset_password_instructions
  end

  private

  def log_event
    desc = "Admin user #{email} added up on PR+P"
    EventLog.create(event_date: DateTime.now, fran: nil, lastname: 'HOME OFFICE', user_email: email,
                    event_desc: desc)
  end
end
