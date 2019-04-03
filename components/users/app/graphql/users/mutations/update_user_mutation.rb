module Users
  module Mutations
    class UpdateUserMutation < ::Mutations::BaseMutation
      null true

      argument :id, ID, required: true
      argument :name, String, required: false

      field :user, Types::UserType, null: true

      def resolve(id:, name:)
        user = ::Users::User.find(id)
        user.update_attributes(name: name)
        {
          user: user
        }
      end
    end
  end
end