class CreateSkinColors < ActiveRecord::Migration[7.0]
  def change
    create_table :skin_colors do |t|
      t.integer  :source_system, null: false
      t.integer  :sigim_id
      t.string   :name, null: false
      t.boolean  :validated, null: false, default: false
      t.boolean  :ignore, null: false, default: false

      t.timestamps
    end
  end
end
