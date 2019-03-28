module Users
  module Types
    class UserType < ::Types::BaseObject
      description "A user."
      field :id, ID, null: false
      field :name, String, null:false
    # field :trunacated_preview, String, null: false
    # field :comments, [::Types::CommentType], null: true, 
      # description: "This post's comments, or null if this post has comments disabled."
    end
  end
end