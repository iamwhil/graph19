class CreateCommentTable < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_comments do |t|
      t.references :blog_post
    end
  end
end
