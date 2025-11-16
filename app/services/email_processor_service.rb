# app/services/email_processor_service.rb
class EmailProcessorService
  PARSERS = [
    Parsers::FornecedorAParser,
    Parsers::ParceiroBParser
  ].freeze

  attr_reader :parse_log, :eml_content

  def initialize(parse_log_id)
    @parse_log = ParseLog.find(parse_log_id)
    @eml_content = @parse_log.eml_file.download
  end

  def call
    @parse_log.processing!
    mail_object = Mail.read_from_string(eml_content)
    parser_class = find_parser(mail_object)

    unless parser_class
      @parse_log.failure!
      @parse_log.update!(error_message: "Nenhum parser encontrado para o remetente.")
      return
    end

    result = parser_class.new(eml_content).parse

    if result.success
      handle_success(result)
    else
      handle_failure(result)
    end

  rescue => e
    handle_unexpected_error(e)
  end

  private

  def find_parser(mail_object)
    PARSERS.find { |klass| klass.can_parse?(mail_object) }
  end

  def handle_success(result)
    Customer.create!(
      result.customer_data.merge(parse_log: @parse_log)
    )
    @parse_log.success!
    @parse_log.update!(
      details: result.customer_data,
      error_message: nil
    )
  end

  def handle_failure(result)
    @parse_log.failure!
    @parse_log.update!(
      error_message: result.error_message,
      details: result.customer_data
    )
  end

  def handle_unexpected_error(exception)
    @parse_log.failure!
    @parse_log.update!(
      error_message: "Erro inesperado: #{exception.message}",
      details: {
        backtrace: exception.backtrace.first(5)
      }
    )
  end
end
