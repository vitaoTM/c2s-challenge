class ProcessEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    EmailProcessorService.new(parse_log_id).call
  end
end
