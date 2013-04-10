class AddAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :bio, :text
    add_column :users, :url, :string
  end
end
