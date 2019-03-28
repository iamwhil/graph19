module Users
  module Types
    class UserType < ::Types::BaseObject
      description "A user."
      field :id, ID, null: false
      field :name, String, null:false
    end
  end
end