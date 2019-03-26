class CreateCommentTable < ActiveRecord::Migration[6.0]
  def change
    create_table :comment_tables do |t|
      t.references :post
    end
  end
end
