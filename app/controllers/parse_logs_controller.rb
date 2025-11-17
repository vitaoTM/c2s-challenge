class ParseLogsController < ApplicationController
  def index
    @parse_logs = ParseLog.order(created_at: :desc)
  end

  def create
    file = params[:parse_log][:eml_file]

    unless file
      redirect_to root_path, alert: "Você precisa selecionar um arquivo."
      return
    end

    @parse_log = ParseLog.new(
      status: "pending",
      original_filename: file.original_filename
    )
    @parse_log.eml_file.attach(file)

    if @parse_log.save
      ProcessEmailJob.perform_now(@parse_log.id)
      redirect_to parse_logs_path, notice: "Arquivo '#{file.original_filename}' enviado para processamento."
    else
      redirect_to root_path, alert: "Erro ao salvar o arquivo."
    end
  end
end
