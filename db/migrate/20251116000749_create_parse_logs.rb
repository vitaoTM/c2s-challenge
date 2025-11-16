class CreateParseLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :parse_logs do |t|
      t.string :status
      t.string :original_filename
      t.jsonb :details
      t.text :error_message

      t.timestamps
    end
  end
end
