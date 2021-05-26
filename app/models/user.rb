# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  belongs_to :franchise
  
  devise :database_authenticatable,
         :recoverable, :rememberable,
         :validatable, :trackable,
         :timeoutable, :registerable,
         :masqueradable

  enum role: [:full_control, :can_pay, :data_entry]

  scope :franchise_users, -> (target_franchise_id) { where('franchise_id = ?', target_franchise_id).order('created_at ASC') }
  
  after_initialize :set_default_role, if: :new_record?
  after_create :log_event

  def set_default_role
  	self.role ||= :full_control
  end

  def reset_pass
    self.send_reset_password_instructions
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
