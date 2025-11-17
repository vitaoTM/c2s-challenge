module Parsers
  class ParceiroBParser < BaseParser
    def self.can_parse?(mail)
      mail.from.any? { |addr| addr.downcase.include?("parceirob.com") }
    end

    def parse
      customer_data = {
        name: body_text[/^(?:Cliente|Nome completo|Nome do cliente): (.*)$/i, 1]&.strip,
        email: body_text[/^(?:email|e-mail|email de contato|e-mail de contato): (.*)$/i, 1]&.strip,
        phone: body_text[/^Telefone: (.*)$/i, 1]&.strip,
        product_code: body_text[/^(?:Produto de interesse|Código do produto|Produto): (.*)$/i, 1]&.strip,
        subject: subject
      }
      if customer_data[:product_code].blank?
         customer_data[:product_code] = subject[/([A-Z0-9-]+)$/, 1]&.strip
      end
      validate_and_build_result(customer_data)
    end
  end
end
