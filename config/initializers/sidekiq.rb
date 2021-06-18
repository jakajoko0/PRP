job_array = [
  {
	  'name' => 'Daily Unattached Document Cleanup ',
	  'class' => 'DailyAttachmentsCleanup',
    'cron' => '0 1 * * *'
  },
  {
  	'name' => 'Periodic Bank Payment Transfers',
  	'class' => 'TransferBankPaymentWorker',
  	'cron' => '0 0,2,4,6,8,10,12,14,16,18,20,22 * * *'
  },
  {
    'name' => 'Royalty Reminder',
    'class' => 'RemittanceReminderWorker',
    'cron' => '0 5 * * *'
  }
]

if Sidekiq.server?
	Sidekiq::Cron::Job.load_from_array! job_array
end