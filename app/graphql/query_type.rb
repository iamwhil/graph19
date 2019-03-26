class QueryType < GraphQL::Schema::Object
  description "The query root of this schema"

  field :post, ::Types::PostType, null: true do 
    description "Find a post by ID"
    argument :id, ID, required: true
  end

  def post(id:)
    Post.find(id)
  end

  field :comment, ::Types::CommentType, null: true do 
    description "Comment for a post."
    argument :id, ID, required: true
  end

  def comment(id:)
    Comment.find(id)
  end
  
end