module Users
  module Mutations
    extend ActiveSupport::Concern

    included do 
      field :update_user, mutation: ::Users::Mutations::UpdateUserMutation
      field :rename_user, mutation: ::Users::Mutations::RenameUserMutation # Resolves with a resolver.
    end

  end
end