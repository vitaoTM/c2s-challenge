class AddParseLogToCustomer < ActiveRecord::Migration[8.0]
  def change
    add_reference :customers, :parse_log, null: false, foreign_key: true
  end
end
