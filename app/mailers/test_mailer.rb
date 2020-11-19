class TestMailer < ApplicationMailer

  def welcome_email
    mail(to: 'dgrenier@smallbizpros.com', subject: "Welcome to Sidekiq")	
  end
end