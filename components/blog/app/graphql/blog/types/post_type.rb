module Blog
  module Types
    class PostType < ::Types::BaseObject
      description "A blog post."
      field :id, Integer, null: false
      field :title, String, null:false
      field :trunacated_preview, String, null: false
      field :comments, [::Blog::Types::CommentType], null: true, 
        description: "This post's comments, or null if this post has comments disabled."
    end
  end
end
