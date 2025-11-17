require 'rails_helper'

RSpec.describe Parsers::ParceiroBParser do
  let(:complete_eml) { File.read("spec/fixtures/files/emails/email4.eml") }
  let(:other_eml) { File.read("spec/fixtures/files/emails/email1.eml") }
  let(:failure_eml) { File.read("spec/fixtures/files/emails/email7.eml") }

  describe ".can_parse?" do
    it "returns true for fornecedora emails" do
      mail = Mail.read_from_string(complete_eml)
      expect(described_class.can_parse?(mail)).to be true
    end

    it 'returns false for emails not from parceirob' do
      mail = Mail.read_from_string(other_eml)
      expect(described_class.can_parse?(mail)).to be false
    end
  end

  describe "#parse" do
    context "with a full email(email4.eml)" do
      subject(:result) { described_class.new(complete_eml).parse }

      it "returns success" do
        expect(result.success).to be true
      end

      it "extract customer's name" do
        expect(result.customer_data[:name].to_s).to eq("Ana Costa")
      end

      it 'extract customers email' do
        expect(result.customer_data[:email]).to eq("ana.costa@example.com")
      end

      it "extract customer's phone" do
        expect(result.customer_data[:phone].to_s).to eq("+55 31 97777-1111")
      end

      it "extract product code" do
        expect(result.customer_data[:product_code].to_s).to eq("PROD-555")
      end

      it "does not show error message" do
        expect(result.error_message).to be(nil)
      end
    end

    context 'with an incomplete email(email7.eml)' do
      subject(:result) { described_class.new(failure_eml).parse }

      it 'returns fail' do
        expect(result.success).to be false
      end

      it 'returns full error message' do
        expect(result.error_message).to eq("Informação de contato ausente.")
      end
    end
  end
end
