class CreateAutoIgnoreName < ActiveRecord::Migration[7.0]
  def change
    create_table :auto_ignore_names do |t|
      t.string   :name, null: false
      t.boolean  :status, null: false, default: true

      t.timestamps
    end
  end
end
