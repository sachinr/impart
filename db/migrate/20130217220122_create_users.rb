class CreateUsers < ActiveRecord::Migration
  create_table :users do |t|
    t.timestamps
    t.string :username
  end
end
