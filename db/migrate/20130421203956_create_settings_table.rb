class CreateSettingsTable < ActiveRecord::Migration
  def up
    create_table :site_settings do |t|
      t.string :name
      t.text :value
      t.string :value_type
      t.timestamps
    end
  end

  def down
    drop_table :site_settings
  end
end
