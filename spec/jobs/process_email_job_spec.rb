require 'rails_helper'

RSpec.describe ProcessEmailJob, type: :job do
  let!(:parse_log) do
    ParseLog.create!(
      status: 'pending',
      original_filename: 'test.eml'
    )
  end

  let(:mock_service) { instance_double(EmailProcessorService) }

  before do
    allow(EmailProcessorService).to receive(:new).with(parse_log.id).and_return(mock_service)
    allow(mock_service).to receive(:call)
  end

  it "calls EmailProcessorService with correct ID" do
    perform_enqueued_jobs do
      ProcessEmailJob.perform_later(parse_log.id)
    end
    expect(mock_service).to have_received(:call).once
  end
end
