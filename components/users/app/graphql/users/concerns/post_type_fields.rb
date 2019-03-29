module Users
  module Concerns
    module PostTypeFields
      extend ActiveSupport::Concern
      ROOT = "Blog::Types::PostType"

      included do

        field :user, ::Users::Types::UserType, null: false do 
          description "User for a given post."
          argument :id, Integer, required: true
        end
      end

      def user(id:)
        ::Users::User.find(id)
      end

      puts 'Triggered'

    end
  end
end
