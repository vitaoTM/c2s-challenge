class PruneOldLogsJob
  include Sidekiq::Job
  queue_as :default

  def perform
    old_logs = ParseLog.where("created_at < ?", 1.days.ago).where.not(status: "success")

    old_logs.destroy_all
  end
end
