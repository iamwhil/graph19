class PostQuery < GraphQL::Schema::Object
  field :post, ::Types::PostType, null: true do 
    description "Find a post by ID"
    argument :id, ID, required: true
  end

  def post(id:)
    Post.find(id)
  end
end