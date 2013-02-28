class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :commentable_id
      t.string  :commentable_type
      t.text    :content
      t.integer :ups, default: 0
      t.integer :downs, default: 0

      t.timestamps
    end
  end
end
