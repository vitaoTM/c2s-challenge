require "mail"

module Parsers
  class BaseParser
    attr_reader :mail

    ParserResult = Struct.new(:success, :customer_data, :error_message, keyword_init: true)

    def initialize(eml_content)
      @mail = Mail.read_from_string(eml_content)
    end

    def parse
      raise NotImplementedError, "#{self.class} não implementou o método 'parse'"
    end

    def self.can_parse?(_mail)
      raise NotImplementedError, "#{self.class} não implementou o método 'can_parse?'"
    end

    protected

    def body_text
      @body_text ||= mail.body.decoded.force_encoding("UTF-8")
    end

    def subject
      @subject ||= mail.subject
    end

    def validate_and_build_result(data)
      if data[:email].blank? && data[:phone].blank?
        return ParserResult.new(
          success: false,
          customer_data: data,
          error_message: "Informação de contato (email ou telefone) ausente."
        )
      end

      ParserResult.new(success: true, customer_data: data)
    end
  end
end
