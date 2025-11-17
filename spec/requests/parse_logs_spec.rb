require 'rails_helper'

RSpec.describe "ParseLogs", type: :request do
  describe "POST /parse_logs" do
    include ActionDispatch::TestProcess::FixtureFile

    let(:file_upload) do
      fixture_file_upload(Rails.root.join("spec/fixtures/files/emails/email1.eml"), 'message/rfc822')
    end

    let(:valid_params) { { parse_log: { eml_file: file_upload } } }
    let(:invalid_params) { { parse_log: { eml_file: nil } } }

    context "with valid params" do
      before { clear_enqueued_jobs }

      it "creates a new ParseLog" do
        expect { post parse_logs_path, params: valid_params }
          .to change(ParseLog, :count).by(1)
      end

      it "redirects to logs page" do
        post parse_logs_path, params: valid_params
        expect(response).to redirect_to(parse_logs_path)
      end

      it "enqueue ProcessEmailJob" do
        post parse_logs_path, params: valid_params

        expect(ProcessEmailJob).to have_been_enqueued.with(ParseLog.last.id)
      end
    end

    context "with invalid params" do
      it "does not create a new ParseLog" do
        expect { post parse_logs_path, params: invalid_params }
          .not_to change(ParseLog, :count)
      end

      it "does not enqueue a job" do
        clear_enqueued_jobs
        post parse_logs_path, params: invalid_params
        expect(ProcessEmailJob).not_to have_been_enqueued
      end
    end
  end
end
