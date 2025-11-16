module Parsers
  class FornecedorAParser < BaseParser
    def self.can_parse?(mail)
      mail.from.any? { |addr| addr.include?("fornecedora.com") }
    end

    def parse
      customer_data = {
        name: body_text[/^Nome(?: do cliente)?: (.*)$/m, 1]&.strip,
        email: body_text[/^E-mail: (.*)$/m, 1]&.strip,
        phone: body_text[/^Telefone: (.*)$/m, 1]&.strip,
        product_code: subject[/([A-Z0-9-]+)$/, 1]&.strip,
        subject: subject
      }

      validate_and_build_result(customer_data)
    end
  end
end
