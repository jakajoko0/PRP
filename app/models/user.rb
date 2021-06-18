# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
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
  ROLES = {"full_control" => "Full Control", "can_pay" => "Entry and Payments", "data_entry" => "Data Entry Only"}
  belongs_to :franchise
  
  devise :database_authenticatable,
         :recoverable, :rememberable,
         :validatable, :trackable,
         :timeoutable, :registerable,
         :masqueradable

  enum role: [:full_control, :can_pay, :data_entry]

  scope :franchise_users, -> (target_franchise_id) { where('franchise_id = ?', target_franchise_id).order('created_at ASC') }
  scope :all_active, -> { where("franchise_id NOT IN (Select id FROM franchises where inactive = 1)") } 
  
  after_initialize :set_default_role, if: :new_record?
  after_create :log_event

  def set_default_role
  	self.role ||= :full_control
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
      
    
    


  def show_excluded?
    self.franchise.show_exempt_collect == 1
  end

  def self.filter_user(search)
    if search
      User.joins(:franchise).where("(lower(lastname) LIKE ?)","%#{search.downcase}%").order("franchises.lastname") 
    else
      User.joins(:franchise).order("franchises.lastname")       
    end
  end

  private

  def log_event
    desc = "#{self.email} signed up on PR+P"
    EventLog.create(event_date: DateTime.now, fran: self.franchise.franchise_number, lastname: self.franchise.lastname, user_email: self.email, event_desc: desc)
  end     
end
