class DashboardController < ApplicationController
  def index
    @parse_log = ParseLog.new
  end
end
