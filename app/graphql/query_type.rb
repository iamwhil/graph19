class QueryType < GraphQL::Schema::Object
  description "The query root of this schema"

  include QueryTypes::PostQueryType
  include Users::QueryTypes::UserQueryType

  field :comment, ::Types::CommentType, null: true do 
    description "Comment for a post."
    argument :id, ID, required: true
  end

  def comment(id:)
    Comment.find(id)
  end

end