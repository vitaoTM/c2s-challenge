class ProcessEmailJob < ApplicationJob
  queue_as :default

  def perform(parse_log_id)
    EmailProcessorService.new(parse_log_id).call
  end
end
