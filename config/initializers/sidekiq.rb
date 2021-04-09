job_array = [
{
	'name' => 'Daily Unattached Document Cleanup ',
	'class' => 'DailyAttachmentsCleanup',
  'cron' => '0 1 * * *'
}

]

if Sidekiq.server?
	Sidekiq::Cron::Job.load_from_array! job_array
end