class CreateUsers < ActiveRecord::Migration
  create_table :users do |t|
    t.timestamps
  end
end
