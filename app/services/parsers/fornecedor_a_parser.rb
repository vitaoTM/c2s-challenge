module Parsers
  class FornecedorAParser < BaseParser
    def self.can_parse?(mail)
      mail.from.any? { |addr| addr.downcase.include?("fornecedora.com") }
    end

    def parse
      customer_data = {
        name: body_text[/^Nome(?: do cliente)?: (.*)$/i, 1]&.strip,
        email: body_text[/^E-mail: (.*)$/i, 1]&.strip,
        phone: body_text[/^Telefone: (.*)$/i, 1]&.strip,
        product_code: subject[/([A-Z0-9-]+)$/i, 1]&.strip,
        subject: subject
      }

      validate_and_build_result(customer_data)
    end
  end
end
