class CreatePostTable < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_posts do |t|
      t.string :title, null: false
    end
  end
end
