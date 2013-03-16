class AddRoleAndConfirmedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, default: 'user'
    add_column :users, :confirmed, :boolean, default: 'false'
  end
end
