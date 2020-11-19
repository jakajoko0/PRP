class TestMailWorker
include Sidekiq::Worker

def perform
  TestMailer.welcome_email().deliver_now
end


end