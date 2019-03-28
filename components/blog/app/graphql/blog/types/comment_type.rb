module Blog
  module Types
    class CommentType < ::Types::BaseObject
      field :id, ID, null: false
      field :post, ::Blog::Types::PostType, null: false
    end
  end
end