class QueryType < GraphQL::Schema::Object
  description "The query root of this schema"

  include Blog::QueryTypes::PostQueryType
  include Users::QueryTypes::UserQueryType

end