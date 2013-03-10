class AddStateToComments < ActiveRecord::Migration
  def change
    add_column :comments, :deleted, :boolean
  end
end
