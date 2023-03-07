class CreateViolenceMotivations < ActiveRecord::Migration[7.0]
  def change
    create_table :violence_motivations do |t|
      t.integer  :source_system, null: false
      t.integer  :sigim_id
      t.string   :name, null: false

      t.timestamps
    end
  end
end
