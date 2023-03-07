class AddIgnoreErrorToSystemOccurrence < ActiveRecord::Migration[7.0]
  def change
    add_column :system_occurrences, :ignore_error, :jsonb
  end
end