class AddUserIdToPosts < ActiveRecord::Migration[6.0]
  def self.up
    add_column :posts, :user_id, :integer, null: false
  end

  def self.down 
    remove_column :posts, :user_id
  end
end
