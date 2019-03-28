class Schema < GraphQL::Schema
  mutation(Types::MutationType)
  query(QueryType)

  orphan_types []

  rescue_from(ActiveRecord::RecordNotFound) { "Not There!" }
end
