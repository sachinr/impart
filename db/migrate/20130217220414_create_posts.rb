class CreatePosts < ActiveRecord::Migration
  create_table :posts do |t|
    t.string :title
    t.string :url
    t.text :description
    t.integer :votes
    t.timestamps
  end
end
