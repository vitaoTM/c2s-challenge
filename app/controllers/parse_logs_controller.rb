class ParseLogsController < ApplicationController
  def index
    @parse_logs = ParseLog.order(created_at: :desc)
  end

  def create
    file = params[:parse_logs][:eml_file]

    unless file
      redirect_to root_path, alert: "É necessário selecionar um arquivo"
    end

    @parse_logs = ParseLog.new(
      status: "pending",
      original_filename: file.original_filename
    )
    @parse_logs.eml_file.attach(file)

    if parse_logs.save
      ProcessEmailJob.perform_async(@parse_logs.id)
      redirect_to parse_logs_path, notice: "Arquivo #{file.original_filename} enviado"
    else
      redirect_to root_path, alert: "Erro ao salvar o arquivo"
    end
  end
end
