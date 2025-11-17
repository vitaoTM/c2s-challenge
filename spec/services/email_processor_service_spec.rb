require 'rails_helper'

RSpec.describe EmailProcessorService do
  def create_log_with_file(fixture_path)
    log = ParseLog.create!(status: 'pending', original_filename: File.basename(fixture_path))
    log.eml_file.attach(
      io: File.open(Rails.root.join(fixture_path)),
      filename: File.basename(fixture_path),
      content_type: 'message/rfc822'
    )
    log
  end
  let(:success_a_path) { "spec/fixtures/files/emails/email1.eml" }
  let(:failure_a_path) { "spec/fixtures/files/emails/email7.eml" }
  let(:success_b_path) { "spec/fixtures/files/emails/email4.eml" }
  let(:failure_b_path) { "spec/fixtures/files/emails/email8.eml" }

  context "with valid email from fornecedor A" do
    let!(:parse_log) { create_log_with_file(success_a_path) }
    subject(:service) { described_class.new(parse_log.id) }

    it "creates new customer" do
      expect { described_class.new(parse_log.id).call }.to change(Customer, :count).by(1)
    end

    it "define log status as 'success'" do
      described_class.new(parse_log.id).call
      parse_log.reload
      expect(parse_log.status).to eq("success")

      expect(parse_log.customer).to be_present
      expect(parse_log.customer.name).to eq("João da Silva")
    end
  end

  context "with a invalid email (email8.eml)" do
    let!(:parse_log) { create_log_with_file(failure_b_path) }
    subject(:service) { described_class.new(parse_log.id) }

    it "does not create a customer" do
      expect { described_class.new(parse_log.id).call }.not_to change(Customer, :count)
    end

    it "define log status as failure" do
      service.call
      expect(parse_log.reload.status).to eq("failure")
    end

    it "grava a mensagem de erro no log" do
      service.call
      expect(parse_log.reload.error_message).to eq("Informação de contato ausente.")
    end
  end
end
