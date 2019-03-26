class Schema < GraphQL::Schema
  mutation(Types::MutationType)
  query(QueryType)

  orphan_types [::Types::CommentType]

  rescue_from(ActiveRecord::RecordNotFound) { "Not There!" }
end
