class CreateSystemOccurrences < ActiveRecord::Migration[7.0]
  def change
    create_table :system_occurrences do |t|
      t.integer :origin_id
      t.integer :source_system, null: false
      t.integer :type_data, null: false
      t.integer :last_page_loaded, null: false
      t.string  :params
      t.string  :url_endpoint
      t.jsonb   :response, null: false
      t.jsonb   :import_error
      t.boolean :already_imported, null: false, default: false

      t.timestamps
    end
  end
end
