class AddMessageIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :message_id, :string
  end
end
