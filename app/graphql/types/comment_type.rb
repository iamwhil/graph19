class Types::CommentType < Types::BaseObject
  field :id, ID, null: false
  field :post, ::Types::PostType, null: false
end