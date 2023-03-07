class AddIgnoreToSystemOccurrence < ActiveRecord::Migration[7.0]
  def change
    add_column :system_occurrences, :ignore, :boolean, null: false, default: false
  end
end
