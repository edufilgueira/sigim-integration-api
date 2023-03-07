class CreateHousingSituation < ActiveRecord::Migration[7.0]
  def change
    create_table :housing_situations do |t|
      t.integer  :source_system, null: false
      t.integer  :sigim_id
      t.string   :name, null: false

      t.timestamps
    end
  end
end
