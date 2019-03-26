class CreateCommentTable < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :post
    end
  end
end
