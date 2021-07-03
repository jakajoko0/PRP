# frozen_string_literal: true
class Admin < ApplicationRecord
  ERRORS_TO_RESCUE = [
    EOFError,
    IOError,
    TimeoutError,
    Errno::ECONNRESET,
    Errno::ECONNABORTED,
    Errno::EPIPE,
    Errno::ETIMEDOUT,
    Net::SMTPAuthenticationError,
    Net::SMTPServerBusy,
    Net::SMTPSyntaxError,
    Net::SMTPFatalError,
    Net::SMTPUnknownError,
    Errno::ECONNREFUSED]
  ROLES = {"full_control" => "Full Control", "read_only" => "Read Only"}
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

  def role_description
    ROLES[self.role]
  end

  def reset_pass
    begin
      self.send_reset_password_instructions
    rescue *ERRORS_TO_RESCUE => e 
      SmtpErrorMailer.send_error(e,self.email).deliver_now
    end
  end

  private

  def log_event
    desc = "Admin user #{email} added up on PR+P"
    EventLog.create(event_date: DateTime.now, fran: nil, lastname: 'HOME OFFICE', user_email: email,
                    event_desc: desc)
  end
end
