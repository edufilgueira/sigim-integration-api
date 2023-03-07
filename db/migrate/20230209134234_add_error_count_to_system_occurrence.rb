class AddErrorCountToSystemOccurrence < ActiveRecord::Migration[7.0]
  def change
    add_column :system_occurrences, :error_count, :integer, null: false, default: 0
  end
end