module Users
  module Mutations
    class RenameUserMutation < ::Mutations::BaseMutation
      null true

      argument :id, ID, required: true
      argument :name, String, required: false

      field :user, Types::UserType, null: true

      def resolve(args)
        ::Users::Resolvers::RenameUserMutationResolver.new(object, args, context).call
      end
    end
  end
end