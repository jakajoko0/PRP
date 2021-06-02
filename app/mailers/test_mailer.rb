class TestMailer < ApplicationMailer

  def welcome_email(recipients)
    mail(to: recipients, subject: "Welcome to Sidekiq")	
  end
end