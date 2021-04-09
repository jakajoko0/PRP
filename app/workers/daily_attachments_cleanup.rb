class DailyAttachmentsCleanup
include Sidekiq::Worker 

  def perform
    docs_to_clean = ActiveStorage::Blob.unattached.count
    if docs_to_clean > 0
      ActiveStorage::Blob.unattached
      .where("active_storage_blobs.created_at <= ?",2.days.ago)
      .find_each(&:purge_later)

      CleanupMailer.cleanup_notification(docs_to_clean).deliver_now
    end
  end

end